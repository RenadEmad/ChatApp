import 'dart:developer';

import '../helper/show_snak_bar.dart';
import 'chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../widgets/constants.dart';
import '../widgets/custom_buttom.dart';
import '../widgets/text_container.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  static String id = 'LoginPage';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  bool isLoading = false;
  String? password;
  GlobalKey<FormState> globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: globalKey,
            child: ListView(
              children: [
                const SizedBox(
                  height: 75,
                ),
                Image.asset(
                  kLogo,
                  height: 100,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Scolar Chat',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Pacifico'),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Text(
                      'Log In',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormContainer(
                    onChange: (data) {
                      email = data;
                    },
                    hintText: 'Email'),
                const SizedBox(
                  height: 10,
                ),
                TextFormContainer(
                    obscureText: true,
                    onChange: (data) {
                      password = data;
                    },
                    hintText: 'Password'),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                    text: 'Log In',
                    onTap: () async {
                      if (globalKey.currentState!.validate()) {
                        isLoading = true;
                        setState(() {});
                        try {
                          await LoginUser();
                          Navigator.pushNamed(context, ChatPage.id,
                              arguments: email);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            ShowSnakBar(
                                context, 'No user found for that email');
                            log('No user found for that email');
                            log(e.code);
                          } else if (e.code == 'wrong-password') {
                            ShowSnakBar(context,
                                'Wrong password provided for that user');
                            log('Wrong password provided for that user');
                            log(e.code.toString());
                          } else if (e.code == 'invalid-credential') {
                            ShowSnakBar(context, 'Invalid Credential');
                            log(e.code);
                          }
                        } catch (e) {
                          ShowSnakBar(context, 'There Was An Error');
                          log('There Was An Error');
                        }
                        isLoading = false;
                        setState(() {});
                      } else {
                        log('fdddddddddddddddddddddddddddddddddddddd');
                      }
                    }),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterPage.id);
                        print('from log to reg');
                      },
                      child: const Text(
                        '  Register',
                        style: TextStyle(color: Colors.blue),
                      ),
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

  Future<void> LoginUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      log('User logged in successfully: ${userCredential.user?.email}');
    } catch (e) {
      log('Error during login: $e');
      rethrow;
    }
  }
}
