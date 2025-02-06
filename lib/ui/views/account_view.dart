import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logic/providers/providers.dart';
import '../../config/constants.dart';

class AccountView extends ConsumerStatefulWidget {
  /// UI to manage user account

  const AccountView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccountViewWidgetState();
}

class _AccountViewWidgetState extends ConsumerState<AccountView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authentication);
    final database = ref.read(db);
    final urlLauncher = ref.read(url);
    final mediaWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: white,
          ),
          onPressed: () async {
            // Back to home page
            // ignore: use_build_context_synchronously
            Beamer.of(context).beamToNamed('/home');
          },
        ),
      ),
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
              gapH40,
              Text(
                'Already signed in!',
                style: largeFont,
                textAlign: TextAlign.center,
              ),
              gapH40,
              SizedBox(
                width: mediaWidth * 0.8,
                height: 60,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      white,
                    ),
                  ),
                  // Sign out
                  onPressed: () async {
                    auth.signOut();
                    // ignore: use_build_context_synchronously
                    Beamer.of(context).beamToNamed('/sign-in');
                  },
                  child: Text(
                    'Sign Out',
                    style: blackFont,
                  ),
                ),
              ),
              gapH20,
              // Delete account
              TextButton(
                onPressed: () async {
                  // Confirm deletion
                  showDialog(
                      // ignore: use_build_context_synchronously
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: black,
                          title: Text(
                            'Are you sure you want to delete your account?',
                            style: largeFont,
                          ),
                          actions: [
                            // Cancel deletion
                            TextButton(
                              onPressed: () async {
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                                style: smallFont,
                              ),
                            ),
                            // Delete account
                            TextButton(
                              onPressed: () async {
                                try {
                                  // Delete account from auth
                                  auth.deleteAccount();
                                  // Delete account from firestore
                                  database.deleteUser(userID: auth.user!.uid);
                                } catch (e) {
                                  showMessage(e.toString(), context);
                                } finally {
                                  // Pop dialog
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                  // ignore: use_build_context_synchronously
                                  Beamer.of(context).beamToNamed('/sign-in');
                                }
                              },
                              child: Text(
                                'Delete',
                                style: smallFont,
                              ),
                            ),
                          ],
                        );
                      });
                },
                child: Text(
                  'Delete Account',
                  style: smallFont,
                ),
              ),
              gapH10,
              // Logo to launch O2Tech website
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
                  },
                ),
              ),
              gapH20,
            ],
          ),
        ),
      ),
    );
  }
}
