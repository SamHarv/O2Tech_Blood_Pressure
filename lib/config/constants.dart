import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const green = Color(0xFF84C754);

final darkModeFont = GoogleFonts.openSans(
  textStyle: const TextStyle(
    fontFamily: "Open Sans",
    color: Colors.white,
    fontSize: 18,
  ),
);

final darkModeLargeFont = GoogleFonts.openSans(
  textStyle: const TextStyle(
    fontFamily: "Open Sans",
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontSize: 24,
  ),
);

final darkModeSmallFont = GoogleFonts.openSans(
  textStyle: const TextStyle(
    fontFamily: "Open Sans",
    color: Colors.white,
    fontSize: 16,
  ),
);

final lightModeFont = GoogleFonts.openSans(
  textStyle: const TextStyle(
    fontFamily: "Open Sans",
    color: Colors.black,
    fontSize: 18,
  ),
);

const gapH20 = SizedBox(height: 20);
const gapH10 = SizedBox(height: 10);

// Display an alert dialog with a message
void showMessage(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            message,
            style: darkModeLargeFont,
          ),
        ),
      );
    },
  );
}
