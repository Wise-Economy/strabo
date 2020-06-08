import 'package:flutter/material.dart';

import '../models/Country.dart';

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
                    color: Theme.of(context).textTheme.bodyText1.color),
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
                    color:Theme.of(context).accentColor, shape: BoxShape.circle),
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
