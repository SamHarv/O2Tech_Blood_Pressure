import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/constants.dart';
import '../../../logic/providers/providers.dart';
import '../../widgets/auth_field_widget.dart';

class ForgotPasswordView extends ConsumerStatefulWidget {
  /// UI for resetting password

  const ForgotPasswordView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgotPasswordViewWidgetState();
}

class _ForgotPasswordViewWidgetState extends ConsumerState<ForgotPasswordView> {
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
    final auth = ref.read(authentication);
    final mediaWidth = MediaQuery.sizeOf(context).width;
    final urlLauncher = ref.read(url);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        // back button
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () async {
            // ignore: use_build_context_synchronously
            Beamer.of(context).beamToNamed('/sign-in');
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Receive an email to\nreset your password',
                style: darkModeLargeFont,
                textAlign: TextAlign.center,
              ),
              gapH20,
              AuthFieldWidget(
                textController: _emailController,
                obscurePassword: false,
                hintText: 'Email',
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
                      await auth.resetPassword(
                        email: _emailController.text.trim(),
                      );
                      // Pop loading dialog
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      showMessage(
                        'Check your email to reset your password',
                        // ignore: use_build_context_synchronously
                        context,
                      );
                    } catch (e) {
                      // Pop loading dialog
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      showMessage(e.toString(), context);
                    }
                  },
                  child: Text(
                    'Reset Password',
                    style: lightModeFont,
                  ),
                ),
              ),
              gapH20,
              TextButton(
                onPressed: () async {
                  // ignore: use_build_context_synchronously
                  Beamer.of(context).beamToNamed('/sign-in');
                },
                child: Text(
                  'Sign In',
                  style: darkModeSmallFont,
                ),
              ),
              gapH10,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: InkWell(
                    borderRadius: BorderRadius.circular(32),
                    child: Image.asset(
                      'images/o2tech_white.png',
                      fit: BoxFit.contain,
                      height: 50,
                    ),
                    onTap: () async {
                      urlLauncher.launchO2Tech();
                    }),
              ),
              gapH20,
            ],
          ),
        ),
      ),
    );
  }
}
