import 'package:chat_task/Models/userModel.dart';
import 'package:chat_task/Widgets/messageTextField.dart';
import 'package:chat_task/Widgets/singleMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final UserModel currentUser;
  final String friendId;
  final String friendName;
  const ChatScreen(
      {Key? key,
      required this.currentUser,
      required this.friendId,
      required this.friendName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          friendName,
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(currentUser.uid)
                    .collection('messages')
                    .doc(friendId)
                    .collection('chats')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot snaphot) {
                  if (snaphot.hasData) {
                    if (snaphot.data.docs.length < 1) {
                      return const Center(
                        child: Text("Start your conversation"),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snaphot.data.docs.length,
                          reverse: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            bool isMe = snaphot.data.docs[index]['senderId'] ==
                                currentUser.uid;
                            return SingleMessage(
                                message: snaphot.data.docs[index]['message'],
                                isMe: isMe);
                          });
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          )),
          MessageTextField(currentId: currentUser.uid, friendId: friendId),
        ],
      ),
    );
  }
}
