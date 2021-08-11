// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:simpleems/bottomNavbar.dart';
import 'package:provider/provider.dart';
import './providers/events.dart';
import './providers/auth.dart';
import './loginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //Auth auth = Auth();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Events>(
            create: (ctx) => Events(null, []),
            update: (ctx, auth, previousEvents) => Events(
                auth, previousEvents == null ? [] : previousEvents.items)),
      ],
      child: MaterialApp(
        title: 'SimpleEMS',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: bottomNavbar(),
        routes: {
          '/login': (ctx) => loginScreen(),
        },
      ),
    );
  }
}
