import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/reading_model.dart';

class CsvExport {
  /// Convert readings to CSV and share the file
  static Future<void> exportReadings(
      List<ReadingModel> readings, BuildContext context) async {
    try {
      // Convert readings to list of lists format for CSV
      final List<List<dynamic>> rows = [];

      // Add header row
      rows.add(['Date', 'Time', 'Systolic', 'Diastolic', 'Comments']);

      // Add data rows
      for (final reading in readings) {
        rows.add([
          reading.date.substring(0, 10),
          reading.time,
          reading.systolic,
          reading.diastolic,
          reading.comments,
        ]);
      }

      // Convert to CSV string
      final csvData = const ListToCsvConverter().convert(rows);

      // Get temporary directory to store the file
      final directory = await getApplicationDocumentsDirectory();
      final now = DateTime.now().toIso8601String().replaceAll(':', '-');
      final path = '${directory.path}/bp_readings_${now.substring(0, 10)}.csv';

      // Write CSV to file
      final file = File(path);
      await file.writeAsString(csvData);
      // Share the file
      await Share.shareXFiles([XFile(path)],
          subject: 'Blood Pressure Readings Export',
          sharePositionOrigin: Rect.fromLTWH(
              0,
              0,
              // ignore: use_build_context_synchronously
              MediaQuery.of(context).size.width,
              // ignore: use_build_context_synchronously
              MediaQuery.of(context).size.height / 2));
    } catch (e) {
      rethrow;
    }
  }
}
