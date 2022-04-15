import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    required this.textEditingController,
    required this.hintText,
    required this.icon, this.textInputType=TextInputType.text, this.isObscureText=false,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final String hintText;
  final IconData icon;
  final TextInputType textInputType;
  final bool isObscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 1,
                spreadRadius: 3,
                offset: const Offset(1, 1),
                color: Colors.grey.withOpacity(0.2))
          ]),
      child: TextField(
        obscureText: isObscureText,
        keyboardType: textInputType,
        controller: textEditingController,
        scrollPadding: EdgeInsets.zero,
        cursorHeight: 22,
        decoration: InputDecoration(
          prefixIconConstraints: BoxConstraints(minWidth: 10, minHeight: 10),

          prefixIcon: Padding(padding: EdgeInsets.all(15),
            child: Icon(
              icon,
              color: Colors.redAccent,
              size: 30,
            ),
          ) ,
          hintText: hintText,

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(width: 1.0, color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(width: 1.0, color: Colors.white),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(width: 1.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
