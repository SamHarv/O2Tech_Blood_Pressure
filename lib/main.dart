import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

import 'config/constants.dart';
import 'firebase_options.dart';
import 'logic/routes/routes.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: black,
  ));
  runApp(const ProviderScope(child: O2TechBP()));
}

class O2TechBP extends StatelessWidget {
  const O2TechBP({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: routerDelegate,
      routeInformationParser: BeamerParser(),
      debugShowCheckedModeBanner: false,
      title: 'O2Tech Blood Pressure',
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: green,
          secondary: green,
        ),
        primaryColor: green,
        textTheme: GoogleFonts.openSansTextTheme().apply(
          bodyColor: white,
          displayColor: white,
        ),
        scaffoldBackgroundColor: backgroundColour,
        appBarTheme: AppBarTheme(
          color: backgroundColour,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: black,
          ),
        ),
      ),
    );
  }
}
