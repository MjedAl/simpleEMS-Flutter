import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class profileScreen extends StatefulWidget {
  const profileScreen({Key? key}) : super(key: key);

  @override
  _profileScreenState createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> userData = Provider.of<Auth>(context).userData;

    return userData.isNotEmpty
        ? Column(children: [
            Container(
                color: Colors.blue,
                child: Container(
                  width: double.infinity,
                  height: 200.0,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        userData['picture'] == null
                            ? CircleAvatar(
                                child: Icon(
                                  Icons.person,
                                  size: 70,
                                ),
                                radius: 50.0,
                              )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(
                                  userData['picture'].toString(),
                                ),
                                radius: 50.0,
                              ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          userData['name'],
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                )),
            // TODO show more information about the user
            // Card(
            //   margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            //   clipBehavior: Clip.antiAlias,
            //   color: Colors.white,
            //   elevation: 5.0,
            //   child: Padding(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 8.0, vertical: 22.0),
            //     child: Row(
            //       children: <Widget>[
            //         Expanded(
            //           child: Column(
            //             children: <Widget>[
            //               Text(
            //                 "Created events",
            //                 style: TextStyle(
            //                   color: Colors.blue,
            //                   fontSize: 22.0,
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               ),
            //               SizedBox(
            //                 height: 5.0,
            //               ),
            //               Text(
            //                 "1",
            //                 style: TextStyle(
            //                   fontSize: 20.0,
            //                   color: Colors.blue,
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //         Expanded(
            //           child: Column(
            //             children: <Widget>[
            //               Text(
            //                 "Subscribed events",
            //                 style: TextStyle(
            //                   color: Colors.blue,
            //                   fontSize: 22.0,
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               ),
            //               SizedBox(
            //                 height: 5.0,
            //               ),
            //               Text(
            //                 "4",
            //                 style: TextStyle(
            //                   fontSize: 20.0,
            //                   color: Colors.blue,
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // )
          ])
        : Text('error');
  }
}
