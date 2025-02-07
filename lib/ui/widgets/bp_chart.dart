import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../config/constants.dart';
import '../../data/models/reading_model.dart';

/// Select [TimeRange] to filter the readings in chart
enum TimeRange { week, month, threeMonths, year }

class BPChart extends StatefulWidget {
  /// Line chart to display blood pressure readings

  /// List of blood pressure readings
  final List<ReadingModel> readings;

  const BPChart({super.key, required this.readings});

  @override
  State<BPChart> createState() => _BPChartState();
}

class _BPChartState extends State<BPChart> {
  TimeRange _timeRange = TimeRange.month;
  late List<ReadingModel> _filteredReadings;

  @override
  void initState() {
    super.initState();
    _updateFilteredReadings();
  }

  /// Update [_filteredReadings] based on [_timeRange]
  void _updateFilteredReadings() {
    final now = DateTime.now();
    DateTime cutoffDate;

    switch (_timeRange) {
      case TimeRange.week:
        cutoffDate = now.subtract(const Duration(days: 7));
        break;
      case TimeRange.month:
        cutoffDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case TimeRange.threeMonths:
        cutoffDate = DateTime(now.year, now.month - 3, now.day);
        break;
      case TimeRange.year:
        cutoffDate = DateTime(now.year - 1, now.month, now.day);
        break;
    }

    _filteredReadings = widget.readings
        .where((reading) => DateTime.parse(reading.date).isAfter(cutoffDate))
        .toList();

    // Sort readings by date
    _filteredReadings.sort(
        (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
  }

  /// Get systolic spots for the line chart
  List<FlSpot> _getSystolicSpots() {
    return _filteredReadings.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.systolic.toDouble());
    }).toList();
  }

  /// Get diastolic spots for the line chart
  List<FlSpot> _getDiastolicSpots() {
    return _filteredReadings.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.diastolic.toDouble());
    }).toList();
  }

  /// Get x axis label for the line chart
  String _getBottomTitle(double value) {
    if (value >= 0 && value < _filteredReadings.length) {
      final reading = _filteredReadings[value.toInt()];
      final date = DateTime.parse(reading.date);
      switch (_timeRange) {
        case TimeRange.week:
          return DateFormat('E').format(date); // Day of week
        case TimeRange.month:
          return DateFormat('d').format(date); // Day of month
        case TimeRange.threeMonths:
          return DateFormat('MMM d').format(date); // Month and day
        case TimeRange.year:
          return DateFormat('MMM').format(date); // Month
      }
    }
    return '';
  }

  /// Get systolic and diastolic default target lines
  List<HorizontalLine> _getTargetLines() {
    return [
      HorizontalLine(
        y: 120,
        color: Colors.red,
        strokeWidth: 1,
        dashArray: [5, 5], // Creates a dashed line
      ),
      HorizontalLine(
        y: 80,
        color: Colors.blue,
        strokeWidth: 1,
        dashArray: [5, 5], // Creates a dashed line
      ),
    ];
  }

  /// Get average systolic and diasolic values for time period
  String _getAverageValues() {
    if (_filteredReadings.isEmpty) {
      return 'No readings';
    }

    final systolicSum = _filteredReadings
        .map((reading) => reading.systolic)
        .reduce((a, b) => a + b);
    final diastolicSum = _filteredReadings
        .map((reading) => reading.diastolic)
        .reduce((a, b) => a + b);

    final systolicAverage =
        (systolicSum / _filteredReadings.length).toStringAsFixed(0);
    final diastolicAverage =
        (diastolicSum / _filteredReadings.length).toStringAsFixed(0);

    return 'Avg: $systolicAverage/$diastolicAverage';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Time range selector
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SegmentedButton<TimeRange>(
            segments: [
              ButtonSegment(
                value: TimeRange.week,
                label: Text('W', style: smallFont),
              ),
              ButtonSegment(
                value: TimeRange.month,
                label: Text('M', style: smallFont),
              ),
              ButtonSegment(
                value: TimeRange.threeMonths,
                label: Text('Q', style: smallFont),
              ),
              ButtonSegment(
                value: TimeRange.year,
                label: Text('Y', style: smallFont),
              ),
            ],
            selected: {_timeRange},
            onSelectionChanged: (Set<TimeRange> newSelection) {
              setState(() {
                _timeRange = newSelection.first;
                _updateFilteredReadings();
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: LineChart(
            LineChartData(
              lineBarsData: [
                // Systolic line
                LineChartBarData(
                  spots: _getSystolicSpots(),
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: true),
                ),
                // Diastolic line
                LineChartBarData(
                  spots: _getDiastolicSpots(),
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: true),
                ),
              ],
              extraLinesData: ExtraLinesData(
                horizontalLines: _getTargetLines(),
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _getBottomTitle(value),
                          style: GoogleFonts.openSans(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                    reservedSize: 32,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 20,
                    reservedSize: 40,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                horizontalInterval: 20,
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  bottom: BorderSide(color: Colors.white38),
                  left: BorderSide(color: Colors.white38),
                ),
              ),
              minY: 40, // Minimum BP value
              maxY: 200, // Maximum BP value
            ),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
        ),
        // const SizedBox(height: 16),
        Divider(color: green),
        Text(
          _getAverageValues(),
          style: GoogleFonts.openSans(
            color: white,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}
