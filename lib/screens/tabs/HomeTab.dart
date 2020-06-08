import 'package:flutter/material.dart';

import '../../models/Country.dart';
import '../../screens/CountryScreen.dart';

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
      separatorBuilder: (BuildContext context, index) => Divider(height: 0,),
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
          child: Container(
            color: Colors.white,
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
          ),
        );
      },
    );
  }
}
