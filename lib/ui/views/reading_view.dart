import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:o2_bp/config/constants.dart';

import '../../data/models/reading_model.dart';
import '../../logic/providers/providers.dart';
import '../../logic/services/validation.dart';

enum TimeSelection { am, pm }

class ReadingView extends ConsumerStatefulWidget {
  const ReadingView({super.key, required this.reading});

  final ReadingModel reading;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReadingViewState();
}

class _ReadingViewState extends ConsumerState<ReadingView> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _hoursFocusNode = FocusNode();
  final _minutesFocusNode = FocusNode();
  late Set<TimeSelection> selected;
  String ampm = '';
  late String tempSystolic;
  late String tempDiastolic;
  late String tempComments;
  late String tempHours;
  late String tempMinutes;

  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[600],
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    ampm = widget.reading.time.split(' ')[1];
    selected = widget.reading.time.contains('am')
        ? {TimeSelection.am}
        : {TimeSelection.pm};

    _hoursFocusNode.addListener(() {
      if (_hoursFocusNode.hasFocus) {
        _scrollToBottom();
      }
    });

    _minutesFocusNode.addListener(() {
      if (_minutesFocusNode.hasFocus) {
        _scrollToBottom();
      }
    });

    tempSystolic = widget.reading.systolic.toString();
    tempDiastolic = widget.reading.diastolic.toString();
    tempComments = widget.reading.comments;
    tempHours = widget.reading.time.split(':')[0];
    tempMinutes = widget.reading.time.split(':')[1].split(' ')[0];
    super.initState();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _hoursFocusNode.dispose();
    _minutesFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final systolicController = TextEditingController(text: tempSystolic);
    final diastolicController = TextEditingController(text: tempDiastolic);
    final commentsController = TextEditingController(text: tempComments);
    final hoursController = TextEditingController(text: tempHours);
    final minutesController = TextEditingController(text: tempMinutes);
    final repo = ref.read(db);

    // convert to int
    final year = int.parse(widget.reading.date.substring(0, 4));
    final month = int.parse(widget.reading.date.substring(5, 7));
    final day = int.parse(widget.reading.date.substring(8, 10));

    String date = widget.reading.date;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Beamer.of(context).beamBack();
          },
        ),
        centerTitle: false,
        title: Text(
          'O2Tech BP',
          style: darkModeLargeFont,
        ),
      ),
      body: Container(
        height: MediaQuery.sizeOf(context).height - kToolbarHeight,
        decoration: BoxDecoration(color: Colors.black),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Reading',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: SizedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: systolicController,
                          decoration: const InputDecoration(
                            labelText: 'Systolic',
                          ),
                          keyboardType: TextInputType.number,
                          scrollPadding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          onChanged: (value) => tempSystolic = value,
                        ),
                        TextFormField(
                          controller: diastolicController,
                          decoration: const InputDecoration(
                            labelText: 'Diastolic',
                          ),
                          keyboardType: TextInputType.number,
                          scrollPadding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          onChanged: (value) => tempDiastolic = value,
                        ),
                        TextFormField(
                          controller: commentsController,
                          decoration: const InputDecoration(
                            labelText: 'Comments',
                          ),
                          maxLines: 20,
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          scrollPadding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          onChanged: (value) => tempComments = value,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: CalendarDatePicker(
                            initialDate: DateTime(year, month, day),
                            firstDate: DateTime(2020, 1, 1),
                            lastDate: DateTime.now(),
                            onDateChanged: (dateInput) {
                              date = dateInput.toString();
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: hoursController,
                                  focusNode: _hoursFocusNode,
                                  decoration: const InputDecoration(
                                    labelText: 'Hours',
                                  ),
                                  keyboardType: TextInputType.number,
                                  scrollPadding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  ),
                                  onChanged: (value) => tempHours = value,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: minutesController,
                                  focusNode: _minutesFocusNode,
                                  decoration: const InputDecoration(
                                    labelText: 'Minutes',
                                  ),
                                  keyboardType: TextInputType.number,
                                  scrollPadding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  ),
                                  onChanged: (value) => tempMinutes = value,
                                ),
                              ),
                              SizedBox(width: 8),
                              // select am or pm
                              SegmentedButton(
                                segments: const [
                                  ButtonSegment(
                                    value: TimeSelection.am,
                                    label: Text('AM'),
                                  ),
                                  ButtonSegment(
                                    value: TimeSelection.pm,
                                    label: Text('PM'),
                                  ),
                                ],
                                selected: selected,
                                onSelectionChanged: (newSelection) {
                                  setState(() {
                                    selected = newSelection;
                                    ampm =
                                        newSelection.first == TimeSelection.am
                                            ? 'am'
                                            : 'pm';
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.black,
                              title: const Text(
                                "Delete Reading",
                                style: TextStyle(color: Colors.white),
                              ),
                              content: const Text(
                                "Are you sure you want to delete this reading?",
                                style: TextStyle(color: Colors.white),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    repo.deleteReading(id: widget.reading.id);
                                    Beamer.of(context).beamToNamed('/home');
                                    setState(() {});
                                  },
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Beamer.of(context).beamBack();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            bool valid = true;
                            if (!Validation().validateSystolicDiastolic(
                                systolicController.text,
                                diastolicController.text)) {
                              showMessage(
                                  'Invalid systolic or diastolic value!');
                              valid = false;
                            }

                            if (!Validation().validateTime(
                                hoursController.text, minutesController.text)) {
                              showMessage('Invalid time!');
                              valid = false;
                            }

                            // Ensure time is double digit
                            if (hoursController.text.length == 1) {
                              hoursController.text = '0${hoursController.text}';
                            }
                            if (minutesController.text.length == 1) {
                              minutesController.text =
                                  '0${minutesController.text}';
                            }

                            if (valid) {
                              try {
                                final reading = ReadingModel(
                                  id: widget.reading.id,
                                  systolic: int.parse(systolicController.text),
                                  diastolic:
                                      int.parse(diastolicController.text),
                                  time:
                                      '${hoursController.text}:${minutesController.text} $ampm',
                                  date: date,
                                  comments: commentsController.text,
                                );
                                repo.updateReading(reading: reading);
                                Beamer.of(context).beamBack();
                              } catch (e) {
                                showMessage(e.toString());
                                return;
                              }
                            }
                            setState(() {});
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
