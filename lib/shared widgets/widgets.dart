import 'package:flutter/material.dart';
import 'package:task_mentor_seven/shared%20themes/colors.dart';

Widget customSearchTextField(
    {String hint = "", Function(String)? onSubmitted, bool enabled = true}) {
  return TextField(
    onSubmitted: onSubmitted,
    autofocus: true,
    enabled: enabled,
    decoration: InputDecoration(
        filled: true,
        fillColor: primary,
        hintStyle: TextStyle(color: black.withOpacity(0.3)),
        hintText: hint,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none),
        prefixIcon: Icon(
          Icons.search,
          color: black.withOpacity(0.2),
        )),
  );
}

Widget customTextButton(var size, VoidCallback function) {
  return TextButton(
      onPressed: function,
      style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: secondary,
          fixedSize: Size(size.width, 60)),
      child: Text(
        "Checkout",
        style: TextStyle(color: primary),
      ));
}
