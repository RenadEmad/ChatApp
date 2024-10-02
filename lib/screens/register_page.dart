import 'dart:developer';

import '../helper/show_snak_bar.dart';
import 'chat_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../widgets/custom_buttom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/constants.dart';
import '../widgets/text_container.dart';

class RegisterPage extends StatefulWidget {
  static String id = 'RegisterPage';

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email;

  String? password;

  GlobalKey<FormState> globalKey = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: globalKey,
            child: ListView(
              children: [
                Column(
                  children: [
                    Image.asset(kLogo),
                    const Text(
                      'Scolar Chat',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Pacifico',
                      ),
                    ),
                    const Row(
                      children: [
                        Text(
                          'Register',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    TextFormContainer(
                      hintText: 'Email',
                      obscureText: false,
                      onChange: (data) {
                        email = data;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormContainer(
                      hintText: 'Password',
                      obscureText: true,
                      onChange: (data) {
                        password = data;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      text: 'Register',
                      onTap: () async {
                        if (globalKey.currentState!.validate()) {
                          isLoading = true;
                          setState(() {});
                          try {
                            await registerUser();
                            Navigator.pushNamed(context, ChatPage.id);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              ShowSnakBar(context, 'Weak Password');
                              log('Weak Password');
                            } else if (e.code == 'email-already-in-use') {
                              ShowSnakBar(context, 'Email Already Exists');
                              log('Email Already Exists');
                            }
                          } catch (e) {
                            ShowSnakBar(context, 'There Was An Error');
                          }
                          isLoading = false;
                          setState(() {});
                        } else {}
                      },
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            print('from register to login');
                          },
                          child: const Text(
                            '  Login',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
