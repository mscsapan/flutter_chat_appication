import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/services/database.dart';

class ShowUserChatRoomList extends StatefulWidget {
  final String lastMessages;
  final String chatRoomId;
  final myUserName;

  ShowUserChatRoomList({this.lastMessages, this.chatRoomId, this.myUserName});

  @override
  _ShowUserChatRoomListState createState() => _ShowUserChatRoomListState();
}

class _ShowUserChatRoomListState extends State<ShowUserChatRoomList> {
  String username = " ", profilePic = " ", name = " ";

  getUserInfo() async {
    username =
        widget.chatRoomId.replaceAll(widget.myUserName, "").replaceAll("_", "");
    QuerySnapshot qs = await UserDatabase().showUserList(username);
    name = qs.docs[0]["name"];
    profilePic = qs.docs[0]["imgURL"];
    setState(() {});
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.network(profilePic,height: 40,width: 40),
        Column(
          children: [
            Text(name),
            Text(widget.lastMessages),
          ],
        ),
      ],
    );
  }
}
