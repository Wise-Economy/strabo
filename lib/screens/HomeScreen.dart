import 'package:finwise/models/Country.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../screens/tabs/HomeTab.dart';
import '../screens/tabs/ProfileTab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _seletedTab = 0;

  final _tabsTitles = [
    "Home",
    "Remitance/Transfer",
    "Add Accounts",
    "Profile & Settings"
  ];
  final List<Widget> _tabs = [
    HomeTab(),
    Container(
      child: Center(
        child: Text('Remitance/Transfer'),
      ),
    ),
    Container(
      child: Center(
        child: Text('Add Accounts'),
      ),
    ),
    ProfileTab()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(
          _tabsTitles[_seletedTab],
          style: TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Center(
        child: AnimatedSwitcher(
          child: _tabs[_seletedTab],
          duration: Duration(milliseconds: 300),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _seletedTab,
        onTap: (index) {
          setState(() {
            _seletedTab = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            title: Text('Home'),
            icon: SvgPicture.asset('assets/feather/home.svg',
                color:
                    _seletedTab == 0 ? Theme.of(context).primaryColor : null),
          ),
          BottomNavigationBarItem(
            title: Text('Account'),
            icon: SvgPicture.asset('assets/feather/arrow-right.svg',
                color:
                    _seletedTab == 1 ? Theme.of(context).primaryColor : null),
          ),
          BottomNavigationBarItem(
            title: Text('Account'),
            icon: SvgPicture.asset('assets/feather/plus.svg',
                color:
                    _seletedTab == 2 ? Theme.of(context).primaryColor : null),
          ),
          BottomNavigationBarItem(
            title: Text('Account'),
            icon: SvgPicture.asset('assets/feather/user.svg',
                color:
                    _seletedTab == 3 ? Theme.of(context).primaryColor : null),
          )
        ],
      ),
    );
  }
}
