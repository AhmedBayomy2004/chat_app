import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.text,
    required this.userName,
    required this.havePrevious,
    required this.isMe,
  });
  final String text;
  final String userName;
  final bool havePrevious;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4, left: 8, right: 8),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,

        children: [
          if (!havePrevious)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(userName, style: TextStyle(fontSize: 10)),
            ),
          Container(
            padding: EdgeInsets.all(8),

            decoration: BoxDecoration(
              color:
                  isMe
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),

            child: Text(
              text,
              style: TextStyle(color: isMe ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
