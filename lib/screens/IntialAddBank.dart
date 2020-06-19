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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
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
                            style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.indigo),
                            textAlign: TextAlign.center,
                          ),
                          SvgPicture.network(
                            'https://d1uuj3mi6rzwpm.cloudfront.net/logos/providers/xf/placeholder_global.svg',
                            height: 50,
                            width: 50,
                          ),
                        ],
                      ),
                      FlatButton(
                        onPressed: openSaltEdgeConnection,
                        highlightColor: Colors.transparent,
                        child: Text(
                          '+ Link Bank',
                          style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w300),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.white,
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
                          ),
                        ],
                      ),
                      FlatButton(
                        onPressed: openSaltEdgeConnection,
                        highlightColor: Colors.transparent,
                        child: Text(
                          '+ Link Bank',
                          style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.w300),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 200),
                      child: Text(
                        'Link bank accounts from india and abroad.View all your finances in a single place',
                        style: Theme.of(context).textTheme.overline,
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
