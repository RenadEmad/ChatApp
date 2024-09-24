import 'package:chat_app/screens/register_page.dart';
import 'package:chat_app/widgets/constants.dart';
import 'package:chat_app/widgets/custom_buttom.dart';
import 'package:chat_app/widgets/text_container.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  static String id = 'LoginPage';

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView(
          children: [
            const SizedBox(
              height: 75,
            ),
            Image.asset(
              'assets/images/scholar.png',
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
             TextContainer(hintText: 'Email'),
            const SizedBox(
              height: 10,
            ),
             TextContainer(hintText: 'Password'),
            const SizedBox(
              height: 10,
            ),
            CustomButton(
              text: 'Log In',
            ),
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
    );
  }
}
