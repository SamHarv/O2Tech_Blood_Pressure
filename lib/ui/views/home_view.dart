import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2_bp/config/constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../data/models/reading_model.dart';
import '../../logic/providers/providers.dart';
import '../../logic/services/csv_export.dart';
import '../widgets/bp_chart.dart';
import '../widgets/new_reading_dialog.dart';

class HomeView extends ConsumerStatefulWidget {
  /// [HomeView] to display blood pressure readings

  const HomeView({super.key, required this.title});

  /// [title] for display in appBar
  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    final repo = ref.read(db);
    final urlLauncher = ref.read(url);

    /// [getReadings] to retrieve readings from repository
    Future<List<ReadingModel>> getReadings() async {
      final readings = await repo.getReadings();
      return readings;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          widget.title,
          style: largeFont,
        ),
        actions: [
          // Export data
          Tooltip(
            message: 'Export Data',
            child: IconButton(
              iconSize: 24,
              color: Colors.white,
              icon: const Icon(Icons.file_download),
              onPressed: () async {
                try {
                  if (kIsWeb) {
                    // ignore: use_build_context_synchronously
                    showMessage('Export not supported on web!', context);
                    return;
                  }
                  // Export data
                  final readings = await repo.getReadings();
                  await CsvExport.exportReadings(readings);
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  showMessage('An error occurred! $e', context);
                }
              },
            ),
          ),
          // Navigate to account view
          Tooltip(
            message: 'Account View',
            child: IconButton(
              iconSize: 24,
              color: Colors.white,
              icon: const Icon(Icons.person),
              onPressed: () async {
                // ignore: use_build_context_synchronously
                Beamer.of(context).beamToNamed('/account');
              },
            ),
          ),
          // O2Tech logo to launch website
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 16),
            child: Tooltip(
              message: 'Launch O2Tech Website',
              child: InkWell(
                borderRadius: BorderRadius.circular(32),
                child: Image.asset(
                  'images/o2tech_white.png',
                  fit: BoxFit.contain,
                  height: 20,
                ),
                onTap: () async =>
                    urlLauncher.launchO2Tech(), // Launch O2Tech website
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.infinity,
              child: FutureBuilder(
                future: getReadings(), // Retrieve readings for chart
                builder: (context, snapshot) {
                  // Loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // Error
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      'Error: ${snapshot.error}',
                      style: font,
                    ));
                  }
                  // Can display chart with or without data
                  return BPChart(readings: snapshot.data!);
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.infinity,
              child: FutureBuilder(
                future: getReadings(), // Retrieve readings for list
                builder: (context, snapshot) {
                  // Loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  // Error
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'An error occurred! ${snapshot.error}',
                        style: font,
                      ),
                    );
                  }
                  final readings = snapshot.data!;
                  // No readings
                  if (readings.isEmpty) {
                    return Center(
                      child: Text(
                        'No Readings Found!\n\n'
                        'Add a reading by clicking the + button below.',
                        textAlign: TextAlign.center,
                        style: font,
                      ),
                    );
                  }
                  // Display readings as list
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      // Format date
                      final year = readings[index].date.substring(0, 4);
                      final month = readings[index].date.substring(5, 7);
                      final day = readings[index].date.substring(8, 10);
                      final date = '$day/$month/$year';
                      return Column(
                        children: [
                          // ListTile for each reading
                          Card(
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: green,
                                  width: 1,
                                ),
                              ),
                              title: Text(
                                '${readings[index].systolic}/${readings[index].diastolic}',
                                style: largeFont,
                              ),
                              subtitle: Text(date, style: smallFont),
                              trailing: Text(
                                readings[index].time,
                                style: smallFont,
                              ),
                              onTap: () {
                                Beamer.of(context).beamToNamed(
                                  '/reading',
                                  data: readings[index],
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                    itemCount: snapshot.data!.length,
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: green,
        onPressed: () async {
          // Add a new reading
          await showDialog(
              context: context, builder: (context) => NewReadingDialog());
          setState(() {});
        },
        tooltip: 'Add Reading',
        child: const Icon(
          Icons.add,
          color: white,
        ),
      ),
    );
  }
}
