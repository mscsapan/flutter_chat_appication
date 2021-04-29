import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger_app/function/helper_function.dart';

class UserDatabase {
  Future userDatabaseInfo(String userId, Map<String, dynamic> userMap) async {
    await FirebaseFirestore.instance
        .collection("messages")
        .doc(userId)
        .set(userMap);
  }

  Future<Stream<QuerySnapshot>> getUsersByName(String username) async {
    return FirebaseFirestore.instance
        .collection("messages")
        .where("username", isEqualTo: username)
        .snapshots();
  }

  Future addMessages(
      String chatRoomId, String messageId, Map messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chat")
        .doc(messageId)
        .set(messageInfoMap);
  }

  lastMessageSendBy(String chatRoomId, Map lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  createChatRoom(String chatRoomId, Map chatRoomInfoMap) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if (snapshot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getMessagesFromChatRoom(
      String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chat")
        .orderBy("timeStands", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatUsers() async {
    String myName = await HelperFunction().getUserName();
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("lastMessageTs", descending: true)
        .where("messages", arrayContains: myName)
        .snapshots();
    //2 hours 52 minutes;
  }

 Future<QuerySnapshot> showUserList(String username) async {
    return await FirebaseFirestore.instance
        .collection("messages")
        .where("username", isEqualTo: username)
        .get();
  }
}
