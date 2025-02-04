import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/reading_model.dart';
import '../../logic/providers/providers.dart';
import '../../logic/services/validation.dart';

enum TimeSelection { am, pm }

class NewReadingDialog extends ConsumerStatefulWidget {
  const NewReadingDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReadingDialogState();
}

class _ReadingDialogState extends ConsumerState<NewReadingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _commentsController = TextEditingController();
  final _hoursController = TextEditingController();
  final _minutesController = TextEditingController();
  String date = DateTime.now().toString();
  String ampm = 'am';

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
  Widget build(BuildContext context) {
    final repo = ref.read(db);
    Set<TimeSelection> selected = {TimeSelection.am};
    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: Colors.black,
            title: const Text('Add New Reading'),
            content: Form(
              key: _formKey,
              child: SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _systolicController,
                      decoration: const InputDecoration(
                        labelText: 'Systolic',
                      ),
                      keyboardType: TextInputType.number,
                      scrollPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                    ),
                    TextFormField(
                      controller: _diastolicController,
                      decoration: const InputDecoration(
                        labelText: 'Diastolic',
                      ),
                      keyboardType: TextInputType.number,
                      scrollPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                    ),
                    TextFormField(
                      controller: _commentsController,
                      decoration: const InputDecoration(
                        labelText: 'Comments',
                      ),
                      maxLines: 20,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      scrollPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: CalendarDatePicker(
                        initialDate: DateTime.now(),
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
                              scrollPadding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              controller: _hoursController,
                              decoration: const InputDecoration(
                                labelText: 'Hours',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _minutesController,
                              decoration: const InputDecoration(
                                labelText: 'Minutes',
                              ),
                              keyboardType: TextInputType.number,
                              scrollPadding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
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
                            onSelectionChanged:
                                (Set<TimeSelection> newSelection) {
                              setState(() {
                                selected = newSelection;
                              });
                              ampm = newSelection == {TimeSelection.am}
                                  ? 'am'
                                  : 'pm';
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  String id = '';
                  bool valid = true;
                  if (!Validation().validateSystolicDiastolic(
                      _systolicController.text, _diastolicController.text)) {
                    showMessage('Invalid systolic or diastolic value!');
                    valid = false;
                  }

                  if (!Validation().validateTime(
                      _hoursController.text, _minutesController.text)) {
                    showMessage('Invalid time!');
                    valid = false;
                  }

                  // Ensure time is double digit
                  if (_hoursController.text.length == 1) {
                    _hoursController.text = '0${_hoursController.text}';
                  }
                  if (_minutesController.text.length == 1) {
                    _minutesController.text = '0${_minutesController.text}';
                  }

                  if (valid) {
                    try {
                      const uuid = Uuid();
                      id = uuid.v4();
                      final reading = ReadingModel(
                        id: id,
                        systolic: int.parse(_systolicController.text),
                        diastolic: int.parse(_diastolicController.text),
                        time:
                            '${_hoursController.text}:${_minutesController.text} $ampm',
                        date: date,
                        comments: _commentsController.text,
                      );
                      repo.createReading(reading: reading);
                      Navigator.of(context).pop();
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
        );
      },
    );
  }
}
