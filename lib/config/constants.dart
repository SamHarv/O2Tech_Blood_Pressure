import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const logo = 'images/logo.png';

/// Primary colour [green]
const green = Color(0xFF84C754);

/// Secondary colour [black]
const black = Colors.black;

/// Text colour [white]
const white = Colors.white;

/// [backgroundColour] grey
const backgroundColour = Color(0xFF212121);

/// Default [font]
final font = GoogleFonts.openSans(
  textStyle: const TextStyle(
    fontFamily: "Open Sans",
    color: white,
    fontSize: 18,
  ),
);

/// [largeFont] for larger text
final largeFont = GoogleFonts.openSans(
  textStyle: const TextStyle(
    fontFamily: "Open Sans",
    fontWeight: FontWeight.bold,
    color: white,
    fontSize: 24,
  ),
);

/// [smallFont] for smaller text
final smallFont = GoogleFonts.openSans(
  textStyle: const TextStyle(
    fontFamily: "Open Sans",
    color: white,
    fontSize: 16,
  ),
);

/// [blackFont] for black text on light background
final blackFont = GoogleFonts.openSans(
  textStyle: const TextStyle(
    fontFamily: "Open Sans",
    color: black,
    fontSize: 18,
  ),
);

/// [gapH40] 40px height gap
const gapH40 = SizedBox(height: 40);

/// [gapH20] 20px height gap
const gapH20 = SizedBox(height: 20);

/// [gapH10] 10px height gap
const gapH10 = SizedBox(height: 10);

// Display an alert dialog with a message
void showMessage(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: black,
        title: Center(
          child: Text(
            message,
            style: largeFont,
          ),
        ),
      );
    },
  );
}
