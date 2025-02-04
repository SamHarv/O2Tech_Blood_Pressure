import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2_bp/config/constants.dart';

import '../../data/models/reading_model.dart';
import '../../logic/providers/providers.dart';
import '../widgets/bp_chart.dart';
import '../widgets/new_reading_dialog.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key, required this.title});

  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    final repo = ref.read(db);
    final urlLauncher = ref.read(url);
    Future<List<ReadingModel>> getReadings() async {
      final readings = await repo.getReadings();
      return readings;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          widget.title,
          style: darkModeLargeFont,
        ),
        actions: [
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              child: FutureBuilder(
                future: getReadings(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      'Error: ${snapshot.error}',
                      style: darkModeFont,
                    ));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text(
                      'No readings available!',
                      style: darkModeFont,
                    ));
                  }

                  return BPChart(readings: snapshot.data!);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              child: FutureBuilder(
                future: getReadings(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'An error occurred! ${snapshot.error}',
                        style: darkModeFont,
                      ),
                    );
                  }
                  final readings = snapshot.data!;
                  if (readings.isEmpty) {
                    return Center(
                      child: Text(
                        'No Readings Found!',
                        style: darkModeFont,
                      ),
                    );
                  }

                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final year = readings[index].date.substring(0, 4);
                      final month = readings[index].date.substring(5, 7);
                      final day = readings[index].date.substring(8, 10);
                      final date = '$day/$month/$year';
                      return Column(
                        children: [
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
                                style: darkModeLargeFont,
                              ),
                              subtitle: Text(date, style: darkModeSmallFont),
                              trailing: Text(
                                readings[index].time,
                                style: darkModeSmallFont,
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: green,
        onPressed: () async {
          await showDialog(
              context: context, builder: (context) => NewReadingDialog());
          setState(() {});
        },
        tooltip: 'Add Reading',
        child: const Icon(Icons.add),
      ),
    );
  }
}
