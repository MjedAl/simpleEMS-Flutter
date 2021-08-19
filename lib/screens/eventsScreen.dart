import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import '../providers/events.dart';
import '../providers/event.dart';

class eventsScreen extends StatefulWidget {
  const eventsScreen({Key? key}) : super(key: key);

  @override
  _eventsScreenState createState() => _eventsScreenState();
}

class _eventsScreenState extends State<eventsScreen> {
  Future<void> _refreshEvents(BuildContext context) async {
    Provider.of<Events>(context, listen: false).update();
  }

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    //print('rebuild');
    final scaffoldKey = new GlobalKey<ScaffoldState>();

    return RefreshIndicator(
      onRefresh: () => _refreshEvents(context),
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          FutureBuilder(
            future: Provider.of<Events>(context).getEvents(),
            builder: (ctx, data) {
              // print(data.connectionState);
              //print(';');
              //  print(data.error);
              //print(';');
              //   print(data.data);
              if (data.connectionState == ConnectionState.waiting) {
                return Shimmer.fromColors(
                  enabled: true,
                  baseColor: Colors.grey[400]!,
                  highlightColor: Colors.grey[100]!,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (_, __) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: placeHolderEvent(),
                    ),
                    separatorBuilder: (_, __) => const SizedBox(height: 2),
                  ),
                );
              } else {
                // we have data, lets check for errors
                // print('error status:' + data.error.toString());
                if (data.error != null) {
                  //  print('error');
                  //print(data.error.toString());
                  return Center(
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          'Whew i\'m sorry :(',
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                      Image(image: AssetImage('assets/images/error_500.png')),
                    ]),
                  );
                } else {
                  var eventsData = data.data as List<Event>;

                  // TODO replace with consumer?
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: eventsData.length,
                    itemBuilder: (_, i) => Column(
                      children: [
                        Column(children: <Widget>[
                          Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  title: new Center(
                                    child: Text(eventsData[i].name),
                                  ),
                                  subtitle: new Center(
                                    child: Text(eventsData[i].description),
                                  ),
                                ),
                                eventsData[i].image != "null"
                                    ? Container(
                                        alignment: Alignment.center,
                                        child: Image.network(
                                          eventsData[i].image,
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Text(''),
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.date_range,
                                            color: Colors.blue,
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text(eventsData[i].monthD),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.watch_later,
                                            color: Colors.blue,
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text(eventsData[i].hourM),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.people,
                                            color: Colors.blue,
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text(eventsData[i]
                                              .currentRegistered
                                              .toString())
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ],
                    ),
                    separatorBuilder: (_, __) => const SizedBox(height: 2),
                  );
                }
              }
            },
          ),
          // eventsData.items.length == 0
          //     ? Shimmer.fromColors(
          //         enabled: true,
          //         baseColor: Colors.grey[400]!,
          //         highlightColor: Colors.grey[100]!,
          //         child: ListView.separated(
          //           shrinkWrap: true,
          //           physics: const ClampingScrollPhysics(),
          //           itemCount: 5,
          //           itemBuilder: (_, __) => Padding(
          //             padding: const EdgeInsets.only(bottom: 4),
          //             child: placeHolderEvent(),
          //           ),
          //           separatorBuilder: (_, __) => const SizedBox(height: 2),
          //         ),
          //       )
          //     : ListView.separated(
          //         shrinkWrap: true,
          //         physics: const ClampingScrollPhysics(),
          //         itemCount: eventsData.items.length,
          //         itemBuilder: (_, i) => Column(
          //           children: [
          //             Column(children: <Widget>[
          //               Card(
          //                 child: Column(
          //                   mainAxisSize: MainAxisSize.min,
          //                   children: <Widget>[
          //                     ListTile(
          //                       title: new Center(
          //                         child: Text(eventsData.items[i].name),
          //                       ),
          //                       subtitle: new Center(
          //                         child: Text(eventsData.items[i].description),
          //                       ),
          //                     ),
          //                     eventsData.items[i].image != "null"
          //                         ? Container(
          //                             alignment: Alignment.center,
          //                             child: Image.network(
          //                               eventsData.items[i].image,
          //                               height: 200,
          //                               width: double.infinity,
          //                               fit: BoxFit.cover,
          //                             ),
          //                           )
          //                         : Text(''),
          //                     Padding(
          //                       padding: EdgeInsets.all(20),
          //                       child: Row(
          //                         mainAxisAlignment:
          //                             MainAxisAlignment.spaceAround,
          //                         children: <Widget>[
          //                           Row(
          //                             children: <Widget>[
          //                               Icon(
          //                                 Icons.date_range,
          //                               ),
          //                               SizedBox(
          //                                 width: 6,
          //                               ),
          //                               Text(eventsData.items[i].timeTemp),
          //                             ],
          //                           ),
          //                           Row(
          //                             children: <Widget>[
          //                               Icon(
          //                                 Icons.watch_later,
          //                               ),
          //                               SizedBox(
          //                                 width: 6,
          //                               ),
          //                               Text("00:00 pm"),
          //                             ],
          //                           ),
          //                           Row(
          //                             children: <Widget>[
          //                               Icon(
          //                                 Icons.people,
          //                               ),
          //                               SizedBox(
          //                                 width: 6,
          //                               ),
          //                             ],
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ]),
          //           ],
          //         ),
          //         separatorBuilder: (_, __) => const SizedBox(height: 2),
          //       ),
        ],
      ),
    );
  }
}

Widget placeHolderEvent() => Container(
      margin: EdgeInsets.all(10),
      child: Column(children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: new Center(
                child: Container(
                  width: 48.0,
                  height: 12.0,
                  color: Colors.white,
                ),
              ),
              subtitle: new Center(
                child: Container(
                  width: 128.0,
                  height: 12.0,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.date_range,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Container(
                        width: 54.0,
                        height: 12.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.watch_later,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Container(
                        width: 54.0,
                        height: 12.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.people,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Container(
                        width: 24.0,
                        height: 12.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
