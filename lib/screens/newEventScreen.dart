import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/events.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import '../models/api_exception.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class newEventScreenRoute extends CupertinoPageRoute {
  newEventScreenRoute()
      : super(builder: (BuildContext context) => new newEventScreen());

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new newEventScreen());
  }
}

class newEventScreen extends StatefulWidget {
  const newEventScreen({Key? key}) : super(key: key);

  @override
  _newEventScreenState createState() => _newEventScreenState();
}

class _newEventScreenState extends State<newEventScreen> {
  @override
  final _formKey = GlobalKey<FormState>();
  //
  XFile? _imageFile;
  final _picker = ImagePicker();
  //

  String _titleValue = "";
  String _descriptionValue = "";
  String _locationValue = "";
  String _dateValue = "";
  bool _loading = false;
  String _errorText = "";
  bool _errorOnFileds = false;
  bool _missingImage = false;

  Future<void> _submit() async {
    setState(() {
      _errorOnFileds = false;
      _errorText = "";
      _missingImage = false;
    });
    if (!_formKey.currentState!.validate()) {
      if (_imageFile == null) {
        setState(() {
          _missingImage = true;
        });
      }
      return;
    } else {
      if (_imageFile == null) {
        setState(() {
          _missingImage = true;
        });
        return;
      }
      _formKey.currentState!.save();
      setState(() {
        _loading = true;
      });

      final bytes = File(_imageFile!.path).readAsBytesSync();
      String _image64 = base64.encode(bytes);

      try {
        DateTime time = DateFormat('yyyy-MM-DD hh:mm').parse(_dateValue);

        await Provider.of<Events>(context, listen: false)
            .addEvent(_titleValue, _descriptionValue, _locationValue,
                time.toUtc().toString(), _image64)
            .then((value) {
          // TODO fix
          Fluttertoast.showToast(
            msg: "Event successfully added :)",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.of(context).pop();
          setState(() {
            _loading = false;
          });
        });
      } on ApiException catch (error) {
        // TODO show error. fix it
        Fluttertoast.showToast(
          msg: error.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        print(error);
        setState(() {
          _loading = false;
        });
      } catch (error) {
        print("rrr" + error.toString());
      }
    }
  }

  Future<void> _onAddImageClick() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => this._imageFile = XFile(pickedFile.path));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New event"),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 24.0),
                  // "Name" form.
                  TextFormField(
                    onSaved: (value) => _titleValue = value as String,
                    enabled: !_loading,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      // filled: true,
                      icon: Icon(Icons.title),
                      labelText: 'Title',
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  // Description
                  TextFormField(
                    onSaved: (value) => _descriptionValue = value as String,
                    enabled: !_loading,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '';
                      }
                      return null;
                    },
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
                  // Image
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Icon(
                            Icons.photo,
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: _imageFile == null
                                  ? Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                              color: _missingImage
                                                  ? Colors.red
                                                  : Colors.grey)),
                                      child: IconButton(
                                        icon: Icon(Icons.add,
                                            color: _missingImage
                                                ? Colors.red
                                                : Colors.grey),
                                        onPressed: () {
                                          _onAddImageClick();
                                        },
                                      ),
                                    )
                                  : Card(
                                      clipBehavior: Clip.antiAlias,
                                      child: Stack(
                                        children: <Widget>[
                                          Image.file(
                                            File(_imageFile!.path),
                                            height: 200,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned(
                                            right: 5,
                                            top: 5,
                                            child: InkWell(
                                              child: Icon(
                                                Icons.remove_circle,
                                                size: 25,
                                                color: Colors.red,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  _imageFile = null;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  // Location
                  TextFormField(
                    onSaved: (value) => _locationValue = value as String,
                    enabled: !_loading,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      //filled: true,
                      icon: Icon(Icons.location_on),
                      labelText: 'Location',
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  // date time
                  DateTimePicker(
                    enabled: !_loading,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '';
                      }
                      return null;
                    },
                    type: DateTimePickerType.dateTimeSeparate,
                    dateMask: 'dd-MM-yyyy',
                    // use24HourFormat: false,
                    initialValue: DateTime.now().toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: Icon(Icons.event),
                    dateLabelText: 'Date',
                    timeLabelText: "Time",
                    onSaved: (value) => _dateValue = value as String,
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    )),
                    onPressed: () {
                      _submit();
                    },
                    child: _loading
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ))
                        : Text("Add", style: TextStyle(color: Colors.white)),
                  ),
                ]),
          )),
    );
  }
}
