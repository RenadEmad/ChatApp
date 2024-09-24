import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.text,
    this.onTap,
   
  });
  final String? text;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        width: double.infinity,
        height: 60,
        child: Center(
          child: Text(
            text!,
            style: TextStyle(fontSize: 18, color: Color(0xFF26435f)),
          ),
        ),
      ),
    );
  }
}
