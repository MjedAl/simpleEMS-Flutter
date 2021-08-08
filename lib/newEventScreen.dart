import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/services.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class newEventScreen extends StatefulWidget {
  const newEventScreen({Key? key}) : super(key: key);

  @override
  _newEventScreenState createState() => _newEventScreenState();
}

class _newEventScreenState extends State<newEventScreen> {
  @override
  List? _myActivities = [];

  Widget build(BuildContext context) {
    // TODO check if user is logged in or not. if not ask him to go to
    // Login first

    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 24.0),
              // "Name" form.
              TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  // filled: true,
                  icon: Icon(Icons.title),
                  labelText: 'Title',
                ),
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                maxLength: 370,
                decoration: const InputDecoration(
                  //filled: true,
                  icon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                  helperText: 'Give a brief description about the event.',
                  labelText: 'Description',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24.0),

              // Category
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Icon(
                        Icons.category,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: MultiSelectFormField(
                              //fillColor: Colors.grey,
                              autovalidate: false,
                              chipBackGroundColor: Colors.blue,
                              chipLabelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              dialogTextStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              checkBoxActiveColor: Colors.blue,
                              checkBoxCheckColor: Colors.white,
                              border: OutlineInputBorder(),
                              dialogShapeBorder: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                              title: Text(
                                "Category",
                                style: TextStyle(fontSize: 16),
                              ),
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return 'Please select one or more options';
                                }
                                return null;
                              },
                              dataSource: [
                                {
                                  "display": "Sport",
                                  "value": "Sport",
                                },
                                {
                                  "display": "Fun",
                                  "value": "Fun",
                                },
                                {
                                  "display": "Meetings",
                                  "value": "Meetings",
                                },
                              ],
                              textField: 'display',
                              valueField: 'value',
                              okButtonLabel: 'OK',
                              cancelButtonLabel: 'CANCEL',
                              //hintWidget: Text('Please choose one or more'),
                              onSaved: (value) {
                                if (value == null) return;
                                setState(() {
                                  _myActivities = value;
                                });
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  //filled: true,
                  icon: Icon(Icons.location_on),
                  labelText: 'Location',
                ),
              ),
              const SizedBox(height: 24.0),
              DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'dd-MM-yyyy',
                // use24HourFormat: false,
                initialValue: DateTime.now().toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                onChanged: (val) => print(val),
                validator: (val) {
                  print(val);
                  return null;
                },
                onSaved: (val) => print(val),
              ),
            ]));
  }
}
