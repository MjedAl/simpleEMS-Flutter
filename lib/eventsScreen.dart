import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class eventsScreen extends StatelessWidget {
  const eventsScreen({Key? key}) : super(key: key);
  // Normal card
  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     margin: EdgeInsets.all(10),
  //     child: Column(children: <Widget>[
  //       Card(
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             ListTile(
  //               title: new Center(
  //                 child: Text('Event Title'),
  //               ),
  //               subtitle: new Center(
  //                 child: Text('Event description'),
  //               ),
  //             ),
  //             Container(
  //               alignment: Alignment.center,
  //               child: Image.network(
  //                 'https://picsum.photos/250?image=9',
  //                 height: 200,
  //                 width: double.infinity,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             Padding(
  //               padding: EdgeInsets.all(20),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 children: <Widget>[
  //                   Row(
  //                     children: <Widget>[
  //                       Icon(
  //                         Icons.date_range,
  //                       ),
  //                       SizedBox(
  //                         width: 6,
  //                       ),
  //                       Text('dd/mm/yyy'),
  //                     ],
  //                   ),
  //                   Row(
  //                     children: <Widget>[
  //                       Icon(
  //                         Icons.watch_later,
  //                       ),
  //                       SizedBox(
  //                         width: 6,
  //                       ),
  //                       Text("00:00 pm"),
  //                     ],
  //                   ),
  //                   Row(
  //                     children: <Widget>[
  //                       Icon(
  //                         Icons.people,
  //                       ),
  //                       SizedBox(
  //                         width: 6,
  //                       ),
  //                       Text("10"),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ]),
  //   );
  // }

  // shrimmer
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        Shimmer.fromColors(
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
        ),
      ],
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
