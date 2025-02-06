class ReadingModel {
  /// [ReadingModel] is a model class that represents a blood pressure reading.

  /// [id] is a unique identifier for the reading.
  final String id;

  /// [systolic] blood pressure value.
  final int systolic;

  /// [diastolic] blood pressure value.
  final int diastolic;

  /// the [time] the reading was taken.
  final String time;

  /// the [date] the reading was taken.
  final String date;

  /// [comments] about the reading.
  final String comments;

  ReadingModel({
    this.id = '',
    required this.systolic,
    required this.diastolic,
    required this.time,
    required this.date,
    required this.comments,
  });
}
