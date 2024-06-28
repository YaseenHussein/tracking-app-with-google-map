import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
  });
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "search here",
        contentPadding: const EdgeInsets.symmetric(
            horizontal:
                16), //this make the text input can change its heigh or width
        fillColor: Colors
            .white, //make the input its color white but should be th parameter filled is true
        filled: true, //this is th parameter
        enabledBorder: customBorder(),
        border: customBorder(),
        focusedBorder: customBorder(),
      ),
    );
  }

  OutlineInputBorder customBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade100),
      borderRadius: const BorderRadius.all(
        Radius.circular(25),
      ),
    );
  }
}
