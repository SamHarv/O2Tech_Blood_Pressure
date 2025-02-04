class ReadingModel {
  final String id;
  final int systolic;
  final int diastolic;
  final String time;
  final String date;
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
