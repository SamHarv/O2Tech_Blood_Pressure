import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/firestore.dart';
import '../services/auth.dart';
import '../services/url_launcher.dart';
import '../services/validation.dart';

/// Singleton for [Firestore] Service
final db = StateProvider((ref) => Firestore());

/// Singleton for [Validation]
final validation = StateProvider((ref) => Validation());

/// Singleton for [Auth]
final authentication = StateProvider((ref) => Auth());

/// Provide singleton for [UrlLauncher]
final url = StateProvider((ref) => UrlLauncher());
