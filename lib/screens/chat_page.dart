import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/screens/login_page.dart';
import 'package:chat_app/widgets/custom_buttom.dart';
import 'package:chat_app/widgets/message_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/constants.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  static String id = 'ChatPage';
  CollectionReference messages = FirebaseFirestore.instance
      .collection(kMessageCollection); // collection name
  TextEditingController controller = TextEditingController();

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // Safely extract email argument from the navigation route
    final email = ModalRoute.of(context)?.settings.arguments as String?;

    // Ensure email is not null before proceeding
    if (email == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text('Chat App'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text('Error: No email provided.'),
            ),
            CustomButton(
              text: 'Login',
              onTap: () {
                Navigator.pushNamed(context, LoginPage.id);
              },
            ),
          ],
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        // Loading state while fetching data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
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
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // Handle error or empty state
        if (snapshot.hasError) {
          return Scaffold(
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
            body: const Center(
              child: Text('Something went wrong. Please try again later.'),
            ),
            bottomNavigationBar: _messageInput(email),
          );
        }

        // Check if there are no messages
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Scaffold(
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
            body: const Center(
              child: Text('No messages yet. Start a conversation!'),
            ),
            bottomNavigationBar: _messageInput(email),
          );
        }

        // If there are messages, display them
        List<MessageModel> messageModelList = snapshot.data!.docs
            .map((doc) =>
                MessageModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        return Scaffold(
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
                  reverse: true,
                  controller: scrollController,
                  itemCount: messageModelList.length,
                  itemBuilder: (context, index) {
                    // Check if the message sender is the current user
                    return messageModelList[index].id == email
                        ? MessageContainer(
                            message: messageModelList[index],
                          )
                        : MessageContainerForFriend(
                            message: messageModelList[index],
                          );
                  },
                ),
              ),
              _messageInput(email),
            ],
          ),
        );
      },
    );
  }

  // Input field and send button
  Widget _messageInput(String email) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        onSubmitted: (data) {
          if (data.isNotEmpty) {
            _addMessage(email);
            controller.clear();
            _scrollToBottom();
          }
        },
        decoration: InputDecoration(
          hintText: 'Send a message...',
          suffixIcon: IconButton(
            icon: const Icon(Icons.send, color: kPrimaryColor),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _addMessage(email);
                controller.clear();
                _scrollToBottom();
              }
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: kPrimaryColor),
          ),
        ),
      ),
    );
  }

  // Function to add a message to Firestore
  void _addMessage(String email) {
    messages.add({
      kMessage: controller.text,
      kCreatedAt: DateTime.now(),
      'senderEmail': email, // Use the email argument
    });
  }

  // Scroll method to keep the chat at the bottom
  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn,
      );
    }
  }
}
