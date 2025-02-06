import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/constants.dart';
import '../../../logic/providers/providers.dart';
import '../../../data/models/user_model.dart';
import '../../widgets/auth_field_widget.dart';

class SignUpView extends ConsumerStatefulWidget {
  /// UI for signing up

  const SignUpView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final database = ref.read(db);
    final auth = ref.read(authentication);
    final validate = ref.watch(validation);
    final urlLauncher = ref.read(url);
    final mediaWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Logo
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
                  // Input first name
                  AuthFieldWidget(
                    textController: _nameController,
                    obscurePassword: false,
                    hintText: 'First Name',
                    mediaWidth: mediaWidth,
                  ),
                  gapH10,
                  // Input email
                  AuthFieldWidget(
                    textController: _emailController,
                    obscurePassword: false,
                    hintText: 'Email',
                    mediaWidth: mediaWidth,
                  ),
                  gapH10,
                  // Input password
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
                          white,
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
                                color: white,
                              ),
                            );
                          },
                        );
                        try {
                          // Validate inputs
                          validate.validateName(_nameController.text.trim()) !=
                                  null
                              ? throw 'Name is required'
                              : null;
                          validate.validateEmail(
                                      _emailController.text.trim()) !=
                                  null
                              ? throw 'Email is invalid'
                              : null;
                          validate.validatePassword(
                                      _passwordController.text.trim()) !=
                                  null
                              ? throw 'Password must be at least 6 characters'
                              : null;
                          // Sign up
                          await auth.signUp(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          );
                          // Create user object
                          final user = UserModel(
                            id: auth.user!.uid,
                            email: _emailController.text.trim(),
                            name: _nameController.text.trim(),
                          );
                          // Add user to database
                          await database.createUser(user: user);
                          // Pop loading dialog
                          //ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          // ignore: use_build_context_synchronously
                          showMessage("User created!", context);
                          //ignore: use_build_context_synchronously
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
                        'Sign Up',
                        style: blackFont,
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
                      style: smallFont,
                    ),
                  ),
                  gapH10,
                  // Logo to launch O2Tech website
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
                        }),
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
