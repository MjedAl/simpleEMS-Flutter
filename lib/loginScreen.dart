import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpleems/models/api_exception.dart';
import '../providers/auth.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  @override
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
  String _emailValue = "";
  String _passwordValue = "";
  bool _loading = false;
  String _errorText = "";
  bool _errorOnFileds = false;

  Future<void> _login() async {
    // reset error text
    setState(() {
      _errorOnFileds = false;
      _errorText = "";
    });
    // validate;
    if (!_formKey.currentState!.validate()) {
      return;
    } else {
      _formKey.currentState!.save();
      try {
        setState(() {
          _loading = true;
          _errorText = '';
        });
        //print('123');
        await Provider.of<Auth>(context, listen: false)
            .login(_emailValue, _passwordValue)
            .then((value) => Navigator.of(context).pop());
        // print('123456');
        // ^ this didn't work
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
        //print("rrr" + error.toString());
      }
    }
  }

  Widget build(BuildContext context) {
    // final forgotLabel = TextButton(
    //   child: Text(
    //     'Forgot password?',
    //     style: TextStyle(color: Colors.black54),
    //   ),
    //   onPressed: () {},
    // );

    return Scaffold(
      appBar: AppBar(
        title: Text("Log in"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              TextFormField(
                onSaved: (value) => _emailValue = value as String,
                keyboardType: TextInputType.emailAddress,
                autofocus: false,
                enabled: !_loading,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Invalid email!';
                  }
                  if (_errorOnFileds) {
                    return " k";
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
              SizedBox(height: 24.0),
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
                    : Text('Log In', style: TextStyle(color: Colors.white)),
              ),
              // forgotLabel
            ],
          ),
        ),
      ),
    );
  }
}
