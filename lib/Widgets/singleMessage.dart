import 'package:flutter/material.dart';

class SingleMessage extends StatelessWidget {
  final String message;
  final bool isMe;
  const SingleMessage({Key? key, required this.message, required this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isMe == true ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 200),
          decoration: BoxDecoration(
              color: isMe == true ? Colors.green : Colors.blue,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
