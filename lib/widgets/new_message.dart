import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatelessWidget {
  const NewMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 4, bottom: 24, top: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              decoration: InputDecoration(
                labelText: 'Send a message...',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 4),
          IconButton(
            onPressed: () async {
              final sentMessage = messageController.text;
              if (sentMessage.trim().isEmpty) {
                return;
              }
              FocusScope.of(context).unfocus();
              messageController.clear();
              final user = FirebaseAuth.instance.currentUser!;
              final userData =
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .get();
              await FirebaseFirestore.instance.collection('chat').add({
                'createdAt': Timestamp.now(),
                'message': sentMessage,
                'user_id': user.uid,
                'username': userData.data()!['username'],
              });
            },
            icon: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
