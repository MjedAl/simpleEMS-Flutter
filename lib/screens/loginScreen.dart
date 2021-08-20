import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpleems/models/api_exception.dart';
import '../providers/auth.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  _loginScreenState createState() => _loginScreenState();
}

class loginScreenRoute extends CupertinoPageRoute {
  loginScreenRoute()
      : super(builder: (BuildContext context) => new loginScreen());

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new loginScreen());
  }
}

class _loginScreenState extends State<loginScreen> {
  @override
  // not working
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        // actions: <Widget>[
        //   FlatButton(
        //     child: Text('Okay'),
        //     onPressed: () {
        //       Navigator.of(ctx).pop();
        //     },
        //   )
        // ],
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  bool _signUp = false;
  String _nameValue = "";
  String _emailValue = "";
  String _passwordValue = "";
  bool _loading = false;
  String _errorText = "";
  bool _errorOnFileds = false;

  Future<void> _login() async {
    setState(() {
      _errorOnFileds = false;
      _errorText = "";
    });
    if (!_formKey.currentState!.validate()) {
      return;
    } else {
      _formKey.currentState!.save();
      try {
        setState(() {
          _loading = true;
        });
        if (_signUp) {
          await Provider.of<Auth>(context, listen: false)
              .signup(_nameValue, _emailValue, _passwordValue)
              .then((value) => Navigator.of(context).pop());
        } else {
          await Provider.of<Auth>(context, listen: false)
              .login(_emailValue, _passwordValue)
              .then((value) => Navigator.of(context).pop());
        }
      } on ApiException catch (error) {
        switch (error.code) {
          case 400:
          case 401:
            setState(() {
              _errorOnFileds = true;
            });
            break;
        }
        setState(() {
          _loading = false;
          _errorText = error.message;
        });
      } catch (error) {
        // TODO handle error
        //print("rrr" + error.toString());
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_signUp ? "Sign up" : "Log in"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              Container(
                child: _signUp
                    ? Column(
                        children: <Widget>[
                          TextFormField(
                            onSaved: (value) => _nameValue = value as String,
                            keyboardType: TextInputType.name,
                            autofocus: false,
                            enabled: !_loading,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Invalid name!';
                              }
                              return null;
                            },
                            decoration: _errorOnFileds
                                ? const InputDecoration(
                                    errorText: "",
                                    border: OutlineInputBorder(),
                                    icon: Icon(Icons.person),
                                    labelText: 'Name',
                                  )
                                : const InputDecoration(
                                    border: OutlineInputBorder(),
                                    icon: Icon(Icons.person),
                                    labelText: 'Name',
                                  ),
                          ),
                          SizedBox(height: 8.0),
                        ],
                      )
                    : null,
              ),

              TextFormField(
                onSaved: (value) => _emailValue = value as String,
                keyboardType: TextInputType.emailAddress,
                autofocus: false,
                enabled: !_loading,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Invalid email!';
                  }
                  return null;
                },
                decoration: _errorOnFileds
                    ? const InputDecoration(
                        errorText: "",
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.email),
                        labelText: 'Email',
                      )
                    : const InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.email),
                        labelText: 'Email',
                      ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                onSaved: (value) => _passwordValue = value as String,
                enabled: !_loading,
                keyboardType: TextInputType.emailAddress,
                autofocus: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Invalid password!';
                  }
                  return null;
                },
                obscureText: true,
                decoration: _errorOnFileds
                    ? const InputDecoration(
                        errorText: "",
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.lock),
                        labelText: 'Password',
                      )
                    : const InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.lock),
                        labelText: 'Password',
                      ),
              ),

              _errorText != ""
                  ? Center(
                      child: Text(
                      _errorText,
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ))
                  : Text(''),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                )),
                onPressed: () {
                  _login();
                },
                child: _loading
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ))
                    : Text(_signUp ? "Sign up" : "Log in",
                        style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 2.0),
              TextButton(
                child: Text(_signUp ? "Log in instead" : "Sign up instead"),
                onPressed: () {
                  setState(() {
                    _errorText = "";
                    _signUp = !_signUp;
                    _errorOnFileds = false;
                  });
                },
              ),
              // TODO
              // SizedBox(height: 2.0),
              // TextButton(
              //     child: Text(
              //       "Reset password",
              //       style: TextStyle(color: Colors.red),
              //     ),
              //     onPressed: () {
              //       showModalBottomSheet(
              //         context: context,
              //         builder: (BuildContext context) => Container(
              //           alignment: Alignment.center,
              //           height: 400,
              //           child: const Text('Dummy bottom sheet'),
              //         ),
              //       );
              //     }),
            ],
          ),
        ),
      ),
    );
  }
}
