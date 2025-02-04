import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/reading_model.dart';
import '../models/user_model.dart';

class Firestore {
  final _users = FirebaseFirestore.instance.collection('users');

  /// Create a user
  Future<void> addUser({required UserModel user}) async {
    try {
      await _users.doc(user.id).set({
        'id': FirebaseAuth.instance.currentUser!.uid,
        'email': user.email,
        'name': user.name,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get a user
  Future<UserModel> getUser({required String userID}) async {
    try {
      final user = await _users.doc(userID).get();
      return UserModel(
        id: user['id'],
        email: user['email'],
        name: user['name'],
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Update user
  Future<void> updateUser({required UserModel user}) async {
    try {
      await _users.doc(user.id).update({
        'id': user.id,
        'email': user.email,
        'name': user.name,
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Delete user
  Future<void> deleteUser({required String userID}) async {
    try {
      await _users.doc(userID).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Create reading
  Future<void> createReading({required ReadingModel reading}) async {
    try {
      await _users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('readings')
          .doc(reading.id)
          .set({
        'id': reading.id,
        'systolic': reading.systolic,
        'diastolic': reading.diastolic,
        'time': reading.time,
        'date': reading.date,
        'comments': reading.comments,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Get reading
  Future<ReadingModel> getReading({required String id}) async {
    try {
      final reading = await _users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('readings')
          .doc(id)
          .get();
      return ReadingModel(
        id: reading['id'],
        systolic: reading['systolic'],
        diastolic: reading['diastolic'],
        time: reading['time'],
        date: reading['date'],
        comments: reading['comments'],
      );
    } catch (e) {
      rethrow;
    }
  }

  // Get readings sorted by date
  Future<List<ReadingModel>> getReadings() async {
    try {
      final readings = await _users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('readings')
          .orderBy('date', descending: true)
          .get();
      return readings.docs
          .map((reading) => ReadingModel(
                id: reading['id'],
                systolic: reading['systolic'],
                diastolic: reading['diastolic'],
                time: reading['time'],
                date: reading['date'],
                comments: reading['comments'],
              ))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  List<ReadingModel> sortReadings(List<ReadingModel> readings) {
    readings.sort((a, b) => a.date.compareTo(b.date));
    return readings;
  }

  // Update reading
  Future<void> updateReading({required ReadingModel reading}) async {
    try {
      await _users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('readings')
          .doc(reading.id)
          .update({
        'systolic': reading.systolic,
        'diastolic': reading.diastolic,
        'time': reading.time,
        'date': reading.date,
        'comments': reading.comments,
      });
    } catch (e) {
      rethrow;
    }
  }

  // Delete reading
  Future<void> deleteReading({required String id}) async {
    try {
      await _users
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('readings')
          .doc(id)
          .delete();
    } catch (e) {
      rethrow;
    }
  }
}
