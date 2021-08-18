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
      'page': profileScreen(),
      'title': 'Profile',
    },
    {
      'page': loginScreen(),
      'title': 'Login',
    },
  ];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  showAlertDialog(BuildContext context, Function logout) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Continue",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        logout();
        _selectPage(0);
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

  void openAddingEventBottomDrawer(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: GestureDetector(
              onTap: () {},
              child: newEventScreen(),
              behavior: HitTestBehavior.opaque,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<Auth>(context);

    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title'] as String),
        actions: _selectedPageIndex == 1
            ? <Widget>[
                IconButton(
                    onPressed: () {
                      showAlertDialog(context, _authData.logout);
                    },
                    icon: Icon(
                      Icons.logout,
                    ))
              ]
            : null,
      ),
      body: _pages[_selectedPageIndex]['page'] as Widget,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Visibility(
          child: FloatingActionButton(
            onPressed: () {
              //openAddingEventBottomDrawer(context);
              Navigator.of(context).push(new newEventScreenRoute());
            },
            child: Icon(Icons.add),
            elevation: 2.0,
          ),
          visible: !keyboardIsOpen &&
              _selectedPageIndex == 0 &&
              _authData.userLoggedIn),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
            onTap: (value) {
              // if user tapped on profile and he is logged in
              if (value == 1) {
                if (_authData.userLoggedIn) {
                  _selectPage(1);
                } else {
                  Navigator.of(context).push(new loginScreenRoute());
                }
              } else {
                _selectPage(value);
              }
            },
            //backgroundColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.black,
            selectedItemColor: Theme.of(context).accentColor,
            currentIndex: _selectedPageIndex,
            // currentIndex: _selectedPageIndex,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.list), label: "Events"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile")
            ]),
      ),
    );
  }
}
