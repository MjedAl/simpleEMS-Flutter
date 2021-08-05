import 'package:flutter/material.dart';
import './eventsScreen.dart';
import './profileScreen.dart';

class bottomNavbar extends StatefulWidget {
  const bottomNavbar({Key? key}) : super(key: key);

  @override
  _bottomNavbarState createState() => _bottomNavbarState();
}

class _bottomNavbarState extends State<bottomNavbar> {
  final List<Map<String, Object>> _pages = [
    {
      'page': eventsScreen(),
      'title': 'Events',
    },
    {
      'page': profileScreen(),
      'title': 'NewE',
    },
    {
      'page': profileScreen(),
      'title': 'Profile',
    },
  ];
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title'] as String),
      ),
      body: _pages[_selectedPageIndex]['page'] as Widget,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _selectPage(1);
        },
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.red,
        notchMargin: 4,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
            onTap: _selectPage,
            //backgroundColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.black,
            selectedItemColor: Theme.of(context).accentColor,
            currentIndex: _selectedPageIndex,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.list), label: "Events"),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile"),
            ]),
      ),
    );
  }
}
