import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../blocs/Connections.dart';
import '../models/AppState.dart';

import 'SaltEdgeScreen.dart';

import '../common/widgets/progress.dart';

class IntialAddBankScreen extends StatefulWidget {
  @override
  _IntialAddBankScreenState createState() => _IntialAddBankScreenState();
}

class _IntialAddBankScreenState extends State<IntialAddBankScreen> {
  Connections _connections;

  @override
  void initState() {
    super.initState();
    _connections = Provider.of<AppState>(context, listen: false).connections;
  }

  Future<void> _showProgress() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return progress();
      },
    );
  }

  openSaltEdgeConnection() async {
    _showProgress();
    if (_connections != null) {
      String connectURL = await _connections.fetchConnectSession();
      Navigator.of(context).pop();
      if (connectURL != null && connectURL.isNotEmpty) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SaltEdgeScreen(connectURL: connectURL)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Card(
                    elevation: 10,
                    shadowColor: Colors.black38,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'INDIA',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(color: Theme.of(context).primaryColor),
                                textAlign: TextAlign.center,
                              ),
                              SvgPicture.network(
                                  'https://d1uuj3mi6rzwpm.cloudfront.net/logos/providers/xf/placeholder_global.svg',
                                  height: 50,
                                  width: 50,
                                  color: Theme.of(context).accentColor),
                            ],
                          ),
                          OutlineButton(
                            onPressed: openSaltEdgeConnection,
                            highlightColor: Colors.transparent,
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            child: Text(
                              '+ Link Bank',
                              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    elevation: 10,
                    color: Colors.white,
                    shadowColor: Colors.black38,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'GERMANY',
                                style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.orange),
                                textAlign: TextAlign.center,
                              ),
                              SvgPicture.network(
                                  'https://d1uuj3mi6rzwpm.cloudfront.net/logos/providers/xf/placeholder_global.svg',
                                  height: 50,
                                  width: 50,
                                  color: Theme.of(context).accentColor),
                            ],
                          ),
                          OutlineButton(
                            onPressed: openSaltEdgeConnection,
                            highlightColor: Colors.transparent,
                            borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            child: Text(
                              '+ Link Bank',
                              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SvgPicture.network(
                      'https://d1uuj3mi6rzwpm.cloudfront.net/logos/providers/xf/placeholder_global.svg',
                      height: 100,
                      color: Colors.white,
                      width: 100,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 270),
                      child: Text(
                        'Link bank accounts from india and abroad.View all your finances in a single place',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Colors.white, fontWeight: FontWeight.w300),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
