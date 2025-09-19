import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No messages yet.'));
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        final loadedMessages = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: loadedMessages.length,

          itemBuilder: (context, index) {
            return MessageBubble(
              text: loadedMessages[index]['message'],
              userName: loadedMessages[index]['username'],
              havePrevious:
                  index < loadedMessages.length - 1
                      ? loadedMessages[index]['user_id'] ==
                          loadedMessages[index + 1]['user_id']
                      : false,
              isMe:
                  FirebaseAuth.instance.currentUser!.uid ==
                  loadedMessages[index]['user_id'],
            );
          },
        );
      },
    );
  }
}
