import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/constants.dart';
import '../../../logic/providers/providers.dart';
import '../../widgets/auth_field_widget.dart';

class SignInView extends ConsumerStatefulWidget {
  /// UI for signing in

  const SignInView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInViewState();
}

class _SignInViewState extends ConsumerState<SignInView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.sizeOf(context).width;
    final auth = ref.read(authentication);
    final logo = 'images/logo.png';
    final urlLauncher = ref.read(url);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // logo
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.asset(
                    logo,
                    width: mediaWidth * 0.5,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
                  AuthFieldWidget(
                    textController: _emailController,
                    obscurePassword: false,
                    hintText: 'Email',
                    mediaWidth: mediaWidth,
                  ),
                  gapH10,
                  AuthFieldWidget(
                    textController: _passwordController,
                    obscurePassword: true,
                    hintText: 'Password',
                    mediaWidth: mediaWidth,
                  ),
                  gapH10,
                  SizedBox(
                    width: mediaWidth * 0.8,
                    height: 60,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        // Show loading dialog
                        showDialog(
                          // ignore: use_build_context_synchronously
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          },
                        );

                        try {
                          await auth.signIn(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          );
                          // Pop loading dialog
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          // ignore: use_build_context_synchronously
                          showMessage("User signed in!", context);

                          // ignore: use_build_context_synchronously
                          Beamer.of(context).beamToNamed('/home');
                        } catch (e) {
                          // Pop loading dialog
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          // ignore: use_build_context_synchronously
                          showMessage(e.toString(), context);
                        }
                      },
                      child: Text(
                        'Sign In',
                        style: lightModeFont,
                      ),
                    ),
                  ),
                  gapH10,
                  TextButton(
                    onPressed: () async {
                      // ignore: use_build_context_synchronously
                      Beamer.of(context).beamToNamed('/sign-up');
                    },
                    child: Text('Sign Up', style: darkModeSmallFont),
                  ),
                  gapH10,
                  TextButton(
                    onPressed: () async {
                      // ignore: use_build_context_synchronously
                      Beamer.of(context).beamToNamed('/forgot-password');
                    },
                    child: Text('Forgot Password', style: darkModeSmallFont),
                  ),
                  gapH10,
                  // O2Tech logo to launch O2Tech website
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(32),
                      child: Image.asset(
                        'images/o2tech_white.png',
                        fit: BoxFit.contain,
                        height: 50,
                      ),
                      onTap: () async {
                        urlLauncher.launchO2Tech();
                      },
                    ),
                  ),
                  gapH20,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
