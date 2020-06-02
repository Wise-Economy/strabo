import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _seletedTab = 0;

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
    Container(
      child: Center(
        child: Text('Profile'),
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Global Dasboard'),
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

class Country {
  String name;
  String flag;

  Country(this.name, this.flag);
}

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<Country> _countries = [
    Country('INDIA',
        'https://upload.wikimedia.org/wikipedia/en/thumb/4/41/Flag_of_India.svg/1200px-Flag_of_India.svg.png'),
    Country('GERMANY',
        'https://upload.wikimedia.org/wikipedia/en/thumb/b/ba/Flag_of_Germany.svg/1200px-Flag_of_Germany.svg.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _countries.length,
      separatorBuilder: (BuildContext context, index) => Divider(),
      itemBuilder: (BuildContext context, index) {
        Country country = _countries[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CountryScreen(_countries[index]),
              ),
            );
          },
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      country.name,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).primaryColor),
                    ),
                    Spacer(),
                    Image.network(
                      country.flag,
                      height: 35,
                      width: 70,
                    )
                  ],
                ),
                Text(
                  '₹ 22,345',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Available           : ',
                    style: DefaultTextStyle.of(context)
                        .style
                        .copyWith(fontSize: 18, fontWeight: FontWeight.w300),
                    children: <TextSpan>[
                      TextSpan(
                        text: '₹ 50,000',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Credit pending : ',
                    style: DefaultTextStyle.of(context)
                        .style
                        .copyWith(fontSize: 18, fontWeight: FontWeight.w300),
                    children: <TextSpan>[
                      TextSpan(
                        text: '₹ 100,000',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                Text(
                  'LAST UPDATED ON 24th Apr 2020',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class CountryScreen extends StatelessWidget {
  final Country country;

  CountryScreen(this.country);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${country.name}'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '${country.name}',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 30,
                    color: Colors.blueGrey),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '₹ 22,345',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 35),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.blueGrey, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    '  ₹ 345\nAvailable',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
