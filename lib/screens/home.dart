import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:messenger_app/function/helper_function.dart';
import 'package:messenger_app/screens/conversation.dart';
import 'package:messenger_app/screens/sign_in.dart';
import 'package:messenger_app/screens/user_chat_list.dart';
import 'package:messenger_app/services/auth.dart';
import 'package:messenger_app/services/database.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearch = false;
  TextEditingController searchEditingController = TextEditingController();
  Stream userStream,chatListStream;
  String myName, myProfilePic, myUserName,myEmail;

 Future onButtonClick() async{
    isSearch = true;
    setState(() {});
   userStream = await UserDatabase().getUsersByName(searchEditingController.text);
    setState(() {});
  }

  Widget searchListTile(String imgUrl,String name,String email){
    return Row(
      children: [
        Image.network(imgUrl),
        Column(
          children: [
            Text(name),
            Text(email)
          ],
        ),

      ],
    );
  }
  Widget onSearchList(){
    return StreamBuilder(
      stream: userStream,
      builder: (BuildContext context ,AsyncSnapshot<dynamic> snapshot){
        return snapshot.hasData? ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
            itemBuilder: (context,index){
            DocumentSnapshot ds = snapshot.data.docs[index];
            return searchByUserName(
              imageUrl: ds["imgURL"],
              email: ds["email"],
              name: ds["name"],
              username: ds["username"],
            );
            }):Center(child: SpinKitFadingCircle(color: Colors.grey),);
      },
    );
  }

  getChatRoomIdByUserNames(String a, String b){
    if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
      return "$b\_$a";
    }else{
      return "$a\_$b";
    }
  }

  getInfoFromSharePreferences()async{
    myName = await HelperFunction().getUserDisplayName();
    myProfilePic = await HelperFunction().getUserProfile();
    myUserName = await HelperFunction().getUserName();
    myEmail = await HelperFunction().getUserEmail();
  }


  Widget searchByUserName(
      {String imageUrl, String name, String username, String email}){
   return GestureDetector(
     onTap: (){

       var chatRoomId = getChatRoomIdByUserNames(myUserName, username);
       Map<String,dynamic> chatRoomInfoMap ={
         "users": [myUserName,username],
       };
       UserDatabase().createChatRoom(chatRoomId, chatRoomInfoMap);

       Navigator.push(context, MaterialPageRoute(
           builder: (context) => ConversationScreen(chatWithName: name,username: username,)));
     },
     child: Row(
       mainAxisAlignment: MainAxisAlignment.start,
       children: [
         ClipRRect(
             borderRadius: BorderRadius.circular(20),
             child: Image.network(imageUrl,width: 40,height: 40,)),
         SizedBox(width: 10.0,),
         Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
             Text(email,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13,color: Colors.black),),
           ],
         ),
       ],
     ),
   );
  }


  chatRoom() async{
    chatListStream = await UserDatabase().getChatUsers();
    setState(() {});
  }

  Widget chatRoomList(){
   return StreamBuilder(
       stream: chatListStream,
       builder: (BuildContext context, snapshot){
     return snapshot.hasData? ListView.builder(
       itemCount: snapshot.data.docs.length,
         shrinkWrap: true,
         itemBuilder: (context,index){
         DocumentSnapshot ds = snapshot.data.docs[index];
       return ShowUserChatRoomList(lastMessages: ds["lastMessages"],chatRoomId: ds.id,myUserName: myUserName);
     }):Center(child: SpinKitFadingCircle(color: Colors.blueGrey,size: 50.0,),);
   });
  }
loadingScreen() async{
  await getInfoFromSharePreferences();
  chatRoomList();
}
  @override
  void initState() {
   loadingScreen();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Messenger Clone"),
      actions: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: (){
              AuthMethod().signOut().then((e){
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SignIn()));
              });
            },
              splashColor: Colors.green,
              child: Container(
                  child: Icon(Icons.exit_to_app))),
        )
      ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
               isSearch? InkWell(
                 onTap: (){
                   isSearch = false;
                   searchEditingController.clear();
                   setState(() {});
                 },
                 child: Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(Icons.arrow_back),
                  ),
               ): Container(),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 1.0,
                        color: Colors.grey,
                        style: BorderStyle.solid
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchEditingController,
                            decoration: InputDecoration(
                              hintText: "username",
                              border: InputBorder.none
                            ),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 25),
                            padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: GestureDetector(
                              onTap: (){
                                if(searchEditingController.text != ""){
                                  onButtonClick();
                                }
                              },
                                child: Icon(Icons.search,color: Colors.white,)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            isSearch ? onSearchList():chatRoomList(),
          ],
        ),
      ),
    );
  }
}
