import 'package:chat_app/widgets/constants.dart';
import 'package:flutter/material.dart';

class MessageContainer extends StatelessWidget {
  const MessageContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, top: 32, bottom: 32, right: 32),
        decoration: const BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            )),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: const Text(
          'hi iam left side message',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
