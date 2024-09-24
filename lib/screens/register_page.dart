import 'package:chat_app/widgets/custom_buttom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/constants.dart';
import 'package:chat_app/widgets/text_container.dart';

class RegisterPage extends StatelessWidget {
  static String id = 'RegisterPage';
  String? email;
  String? password;

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            const Spacer(flex: 2),
            Image.asset('assets/images/scholar.png'),
            const Text(
              'Scolar Chat',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Pacifico',
              ),
            ),
            const Spacer(flex: 2),
            const Row(
              children: [
                Text(
                  'Register',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 15),
            TextContainer(
              hintText: 'Email',
              onChange: (data) {
                email = data;
              },
            ),
            const SizedBox(height: 10),
            TextContainer(
              hintText: 'Password',
              onChange: (data) {
                password = data;
              },
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Register',
              onTap: () async {
                try {
                  var auth = FirebaseAuth.instance;
                  UserCredential user =
                      await auth.createUserWithEmailAndPassword(
                    email: email!,
                    password: password!,
                  );
                  print('User registered: ${user.user!.email}');
                } catch (e) {
                  print('Error: $e');
                  // Optionally show an error message to the user
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Registration failed: $e')),
                  );
                }
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
                    print('Navigating from register to login');
                  },
                  child: const Text(
                    '  Login',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
