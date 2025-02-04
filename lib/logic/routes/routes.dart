import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../data/models/reading_model.dart';
import '../../ui/views/account_view.dart';
import '../../ui/views/auth_views/forgot_password_view.dart';
import '../../ui/views/auth_views/sign_in_view.dart';
import '../../ui/views/auth_views/sign_up_view.dart';
import '../../ui/views/home_view.dart';
import '../../ui/views/reading_view.dart';
import '../services/auth.dart';

Auth auth = Auth(); // Determine if user is signed in

final routerDelegate = BeamerDelegate(
  notFoundRedirectNamed: auth.user == null
      ? '/sign-in'
      : '/home', // check auth status and redirect to '/home' or '/sign-in'
  initialPath: auth.user == null ? '/sign-in' : '/home',
  locationBuilder: RoutesLocationBuilder(
    routes: {
      '/home': (context, state, data) {
        return const BeamPage(
          key: ValueKey('home'),
          type: BeamPageType.noTransition,
          title: 'O2Tech BP',
          child: HomeView(title: 'O2Tech BP'),
        );
      },
      '/reading': (context, state, data) {
        return BeamPage(
          key: const ValueKey('reading'),
          type: BeamPageType.noTransition,
          title: 'Reading',
          child: ReadingView(reading: data as ReadingModel),
        );
      },
      '/sign-in': (context, state, data) {
        return const BeamPage(
          key: ValueKey('sign-in'),
          type: BeamPageType.noTransition,
          title: 'Sign In',
          child: SignInView(),
        );
      },
      '/sign-up': (context, state, data) {
        return const BeamPage(
          key: ValueKey('sign-up'),
          type: BeamPageType.noTransition,
          title: 'Sign Up',
          child: SignUpView(),
        );
      },
      '/forgot-password': (context, state, data) {
        return const BeamPage(
          key: ValueKey('forgot-password'),
          type: BeamPageType.noTransition,
          title: 'Forgot Password',
          child: ForgotPasswordView(),
        );
      },
      '/account': (context, state, data) {
        return const BeamPage(
          key: ValueKey('account'),
          type: BeamPageType.noTransition,
          title: 'Account',
          child: AccountView(),
        );
      },
    },
  ).call,
);
