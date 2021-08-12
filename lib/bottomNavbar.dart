import 'package:flutter/material.dart';
import './screens/eventsScreen.dart';
import './screens/profileScreen.dart';
import './screens/newEventScreen.dart';
import './screens/loginScreen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class bottomNavbar extends StatefulWidget {
  const bottomNavbar({Key? key}) : super(key: key);

  @override
  _bottomNavbarState createState() => _bottomNavbarState();
}

class _bottomNavbarState extends State<bottomNavbar> {
  final List<Map<String, Object>> _pages = [
    {
      'page': eventsScreen(),
      'title': 'Events list',
    },
    {
      'page': newEventScreen(),
      'title': 'New event',
    },
    {
      'page': profileScreen(),
      'title': 'Profile',
    },
    {
      'page': loginScreen(),
      'title': 'Login',
    },
  ];

  int _selectedPageIndex = 0;
  int _selectedPageIndexInBar = 0;

  void _selectPage(int index) {
    setState(() {
      // User is in new event page and clicked on add again
      // call the form submit in that class
      // if (_selectedPageIndex == 1 && index == 1) {
      //   (newEventScreen) _pages[1]['page']
      // }
      _selectedPageIndex = index;
      _selectedPageIndexInBar = index;
    });
  }

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  showAlertDialog(BuildContext context, Function logout) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        logout();
        setState(() {
          _selectedPageIndex = 0;
          _selectedPageIndexInBar = 0;
        });
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Confirmation"),
      content: Text("Are you sure you want to log out?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<Auth>(context);

    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title'] as String),
        actions: _selectedPageIndex == 2
            ? <Widget>[
                IconButton(
                    onPressed: () {
                      showAlertDialog(context, _authData.logout);
                    },
                    icon: Icon(Icons.logout))
              ]
            : null,
      ),
      body: _pages[_selectedPageIndex]['page'] as Widget,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
          child: FloatingActionButton(
            onPressed: () {
              _selectPage(1);
            },
            child: Icon(Icons.add),
            elevation: 2.0,
          ),
          visible: !keyboardIsOpen),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
            onTap: (value) {
              // if user tapped on profile and he is not logged in
              if (value == 2) {
                _authData.token.then((token) {
                  if (token == "") {
                    //
                    Navigator.of(context).pushNamed('/login');
                    // _selectedPageIndex = 3;
                  } else {
                    setState(() {
                      _selectedPageIndex = 2;
                      _selectedPageIndexInBar = 2;
                    });
                  }
                });
              } else {
                _selectPage(value);
              }
            },
            //backgroundColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.black,
            selectedItemColor: Theme.of(context).accentColor,
            currentIndex: _selectedPageIndexInBar,
            // currentIndex: _selectedPageIndex,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.list), label: "Events"),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile")
              // authData.token == ""
              //     ? BottomNavigationBarItem(
              //         icon: Icon(Icons.person), label: "Login")
              //     : BottomNavigationBarItem(
              //         icon: Icon(Icons.person), label: "Profile"),
            ]),
      ),
    );
  }
}
