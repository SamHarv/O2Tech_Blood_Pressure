import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/constants.dart';

class AuthFieldWidget extends ConsumerWidget {
  /// A custom text field widget for the auth fields

  final TextEditingController textController;
  final bool obscurePassword;
  final String hintText;
  final double mediaWidth;

  const AuthFieldWidget({
    super.key,
    required this.textController,
    required this.obscurePassword,
    required this.hintText,
    required this.mediaWidth,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: mediaWidth * 0.8,
      height: 60,
      child: TextField(
        style: darkModeFont,
        controller: textController,
        textInputAction: TextInputAction.next,
        obscureText: obscurePassword,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(64),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          hintText: hintText,
          hintStyle: GoogleFonts.openSans(
            textStyle: TextStyle(
              fontFamily: "Open Sans",
              color: Colors.grey[500],
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
