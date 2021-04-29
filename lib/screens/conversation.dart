import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:messenger_app/function/helper_function.dart';
import 'package:messenger_app/services/database.dart';
import 'package:random_string/random_string.dart';
class ConversationScreen extends StatefulWidget {
  final chatWithName;
  final username;
  ConversationScreen({this.chatWithName,this.username});
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String chatRoomId, messageId = "";
  String myName, myProfilePic, myUserName,myEmail;
  TextEditingController messageTextEditingController = new TextEditingController();
  Stream messageStream;

  getInfoFromSharePreferences()async{
    myName = await HelperFunction().getUserDisplayName();
    myProfilePic = await HelperFunction().getUserProfile();
    myUserName = await HelperFunction().getUserName();
    myEmail = await HelperFunction().getUserEmail();
    chatRoomId = getChatRoomIdByUserNames(widget.chatWithName, myUserName);
  }

  typeMessages(bool isSend){
    if(messageTextEditingController.text  != ""){
      String message = messageTextEditingController.text;
      var lastMessageTs = DateTime.now();

      Map<String, dynamic> messageInfoMap ={
        "message": message,
        "timeStands": lastMessageTs,
        "imgURL" : myProfilePic,
        "sendBy": myUserName,
      };
      if(messageId == ""){
        messageId = randomAlphaNumeric(10);
      }
      UserDatabase().addMessages(chatRoomId, messageId, messageInfoMap).then((value){
        Map<String,dynamic> lastMessageInfoMap = {
          "lastMessages": message,
          "lastMessageTs": lastMessageTs,
          "lastMessageSendBy": myUserName,
        };
        UserDatabase().lastMessageSendBy(chatRoomId, lastMessageInfoMap);
        if(isSend){
          //remove message text filed
          messageTextEditingController.text = "";
          //re-generate for the next message
          messageId = "";
        }
      });
    }
  }

  getChatRoomIdByUserNames(String a, String b){
    if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
      return "$b\_$a";
    }else{
     return "$a\_$b";
    }
  }

  Widget messageStyle(String message,bool isSendByMe){
    return Row(
      mainAxisAlignment: isSendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomLeft: isSendByMe? Radius.circular(25):Radius.circular(0),
              bottomRight: isSendByMe? Radius.circular(0):Radius.circular(25),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 14.0),
          margin: EdgeInsets.symmetric(vertical: 5.0,horizontal: 8.0),
          child: Text(message,style: TextStyle(color: Colors.white,fontSize: 18.0),),
        ),
      ],
    );
  }

  Widget messageList(){
    return StreamBuilder(
      stream: messageStream,
        builder: (BuildContext context, AsyncSnapshot snapshot){
      if(snapshot.hasData){
        return ListView.builder(
            itemCount: snapshot.data.docs.length,
            padding: EdgeInsets.only(bottom: 70,top: 16),
            reverse: true,
            itemBuilder: (context,index){
              DocumentSnapshot ds = snapshot.data.docs[index];
              //2 hours 36 min
              return messageStyle(ds["message"],myUserName==ds["sendBy"]);
            });
      }else{
        return Center(
          child: SpinKitCircle(color: Colors.grey,size: 50.0),
        );
      }
    });
  }

  getAndSetMessages() async{
    messageStream = await UserDatabase().getMessagesFromChatRoom(chatRoomId);
    setState(() {

    });
  }

  doThisOnLaunch() async{
   await getInfoFromSharePreferences();
   getAndSetMessages();
  }
  @override
  void initState() {
    doThisOnLaunch();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatWithName),
      ),
      body: Container(
        child: Stack(
          children: [
            messageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18.0,vertical: 10.0),
                color: Colors.black26.withOpacity(0.7),
                child: Row(
                  children: [
                    Expanded(child: TextField(
                      controller: messageTextEditingController,
                      onChanged: (value){
                        typeMessages(false);
                      },
                      style: TextStyle(fontSize: 20.0,color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "type message..",
                        hintStyle: TextStyle(fontSize: 16.0,color: Colors.white70)
                      ),
                    )),
                    InkWell(
                      onTap: (){
                        typeMessages(true);
                      },
                        child: Icon(Icons.send,color: Colors.white,),
                    focusColor: Colors.blueGrey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
