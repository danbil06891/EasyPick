// ignore_for_file: must_be_immutable

import 'package:easy_pick/constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SimpleTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final IconData? suffixIcon2;
  bool isVisible;
  bool isRead;
  final String? imagePath;

  final Colors? color;
  final TextInputType? inputType;
  final Function(String)? onFieldSubmitted;
  final int? maxLine;
  final Function? onTap;

  SimpleTextField(
      {Key? key,
      this.onTap,
      this.imagePath,
      this.onFieldSubmitted,
      this.isVisible = false,
      required this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.maxLine,
      this.color,
      this.isRead = true,
      required this.controller,
      this.inputType,
      this.suffixIcon2})
      : super(key: key);

  @override
  State<SimpleTextField> createState() => _SimpleTextFieldState();
}

class _SimpleTextFieldState extends State<SimpleTextField> {
  bool visibility = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: widget.maxLine,
      enabled: widget.isRead,
      controller: widget.controller,
      keyboardType: widget.inputType,
      obscureText: widget.isVisible,
      decoration: InputDecoration(
        isDense: true,
        labelText: widget.hintText,
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: Colors.grey,
                size: 26,
              )
            : widget.imagePath != null
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      "${widget.imagePath}",
                      fit: BoxFit.cover,
                    ),
                  )
                : null,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              widget.isVisible = !widget.isVisible;
            });
          },
          child: Icon(
            widget.isVisible ? widget.suffixIcon2 : widget.suffixIcon,
            color: greyColor,
            size: 18,
          ),
        ),
        fillColor: Colors.white,
        filled: true,
      ),
      inputFormatters: widget.inputType == TextInputType.number
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
            ]
          : null,
    );
  }
}
