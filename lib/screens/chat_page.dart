import 'dart:developer';

import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/widgets/message_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../widgets/constants.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  static String id = 'ChatPage';
  CollectionReference messages = FirebaseFirestore.instance
      .collection(kMessageCollection); //collection name , creation
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedAt).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          List<MessageModel> messageModelList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messageModelList.add(MessageModel.fromJson(snapshot.data!.docs[i]));
          }
          print(snapshot.data!.docs[0][kMessage]);
          return Scaffold(
              // retur the widget which i want it to be build when my data is ready
              appBar: AppBar(
                backgroundColor: kPrimaryColor,
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(kLogo),
                    const Text('Chat App'),
                  ],
                ),
                automaticallyImplyLeading: false,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: messageModelList.length,
                        itemBuilder: (context, index) {
                          return MessageContainer(
                            message: messageModelList[index],
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controller,
                      onSubmitted: (data) {
                        messages.add({
                          kMessage: data,
                          kCreatedAt: DateTime.now(),
                        });
                        controller.clear();
                      },
                      decoration: InputDecoration(
                        hintText: 'Send Message..',
                        suffix: const Icon(
                          Icons.send,
                          color: kPrimaryColor,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: kPrimaryColor),
                        ),
                      ),
                    ),
                  )
                ],
              ));
        } else {
          return ModalProgressHUD(
            inAsyncCall: true,
            child: Container(
              child: const Text('Loading'),
            ),
          );
        }
      },
    );
  }
}
