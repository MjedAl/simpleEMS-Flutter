import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  @override
  Widget build(BuildContext context) {
    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        icon: Icon(Icons.email),
        labelText: 'Email',
      ),
    );
    final password = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      obscureText: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        icon: Icon(Icons.lock),
        labelText: 'Password',
      ),
    );

    final loginButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            )),
            onPressed: () {
              Navigator.of(context).pushNamed("/");
            },
            child: Text('Log In', style: TextStyle(color: Colors.white)),
          ),
        ));

    final forgotLabel = TextButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Log in"),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            forgotLabel
          ],
        ),
      ),
    );
  }
}
