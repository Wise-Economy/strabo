import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/Country.dart';
import '../../models/ConnectSession.dart';
import '../../common/widgets/progress.dart';
import '../../common/constants.dart';
import '../../common/widgets/alert.dart';
import '../../models/AppState.dart';
import '../../models/CountriesLinkable.dart';
import '../../api/API.dart';
import '../SaltEdgeScreen.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Server _server;
  SharedPreferences _prefsInstance;
  Future<CountriesLinkable> _countriesLinkable;

  @override
  void initState() {
    super.initState();
    _server = Provider.of<Server>(context, listen: false);
    _prefsInstance = Provider.of<AppState>(context, listen: false).preferences;
    _countriesLinkable = fetchCountriesLinkable();
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

  openBankConnection(int forCountry) async {
    _showProgress();
    String sessionId = _prefsInstance?.getString(Constants.SESSION_ID);
    // TODO Replace fake forCountry ID _server.fetchConnectSession(sessionId, 185);
    final response = await _server.fetchConnectSession(sessionId, 185);
    Navigator.of(context).pop();
    print(response.body);
    if (response.statusCode == 200) {
      ConnectSession _connectSession = ConnectSession.fromRawJson(response.body);
      String connectURL = _connectSession.connectUrl;
      if (connectURL != null && connectURL.isNotEmpty) {
        Map<String, String> result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SaltEdgeScreen(connectURL: connectURL),
          ),
        );
        if (result != null) {
          print('Connection ID:: ${result['connection_id']}');
          await updateServer(_connectSession.userConnectionId, result['connection_id']);
        }
      }
    } else {
      await showAlert(context: context);
    }
  }

  updateServer(int userConnectionId, String seConnectionId) async {
    String sessionId = _prefsInstance?.getString(Constants.SESSION_ID);
    final response = await _server.bankConnectionSuccess(sessionId, userConnectionId, seConnectionId);
    print('update Server:: ${response.body}');
    if (response.statusCode == 200) {
      print('Connection Success Server Updated');
    } else {
      await showAlert(context: context);
    }
  }

  Future<CountriesLinkable> fetchCountriesLinkable() async {
    String sessionId = _prefsInstance?.getString(Constants.SESSION_ID);
    print('SESSION ID:: $sessionId');
    final response = await _server.fetchLinkableCountries(sessionId);
    if (response.statusCode == 200) {
      return CountriesLinkable.fromRawJson(response.body);
    } else {
      throw Exception('Failed to load CountriesLinkable');
    }
  }

  Widget countryCard(Country country, int index) {
    return country.hasAccountsLinked
        ? Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                        country.countryName,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.normal, color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                  Text(
                    '₹ 22,345',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Available           : ',
                      style: DefaultTextStyle.of(context).style.copyWith(fontSize: 18),
                      children: <TextSpan>[
                        TextSpan(
                          text: '₹ 50,000',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Credit pending : ',
                      style: DefaultTextStyle.of(context).style.copyWith(fontSize: 18),
                      children: <TextSpan>[
                        TextSpan(
                          text: '₹ 100,000',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'LAST UPDATED ON 24th Apr 2020',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  )
                ],
              ),
            ),
          )
        : Container(
            height: 160,
            child: Card(
              elevation: 10,
              shadowColor: Colors.black38,
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          country.countryName,
                          style: Theme.of(context).textTheme.headline5.copyWith(color: Theme.of(context).primaryColor),
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
                      onPressed: () => openBankConnection(country.countryId),
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
          );
  }

  Widget recentTransactions() {
    return DraggableScrollableSheet(
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              Center(
                child: Container(
                  height: 6,
                  width: 40,
                  decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Recent Transactions',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text('Today'),
              ),
              SizedBox(height: 10),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      indent: 75,
                      thickness: 2,
                    ),
                    controller: scrollController,
                    itemCount: 15,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionDetailScreen()));
                        },
                        leading: Image.network(
                          "https://www.freepnglogos.com/uploads/netflix-logo-circle-png-5.png",
                          height: 40,
                        ),
                        title: Text('Netflix Inc'),
                        trailing: Text('€ 10.99'),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<CountriesLinkable>(
        future: _countriesLinkable,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Country> _countries = snapshot.data.countriesLinkable;
            return Stack(
              children: <Widget>[
                ListView.builder(
                  itemCount: _countries.length,
                  itemBuilder: (BuildContext context, index) {
                    Country country = _countries[index];
                    return countryCard(country, index);
                  },
                ),
                recentTransactions()
              ],
            );
          } else {
            return Center(
              child: Text('Just a moment ... '),
            );
          }
        },
      ),
    );
  }
}

class TransactionDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transaction'),),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 15),
            Center(
              child: Image.network(
                "https://www.freepnglogos.com/uploads/netflix-logo-circle-png-5.png",
                height: 80,
              ),
            ),
            SizedBox(height: 15),
            Text(
              '€ 10.99',
              style: TextStyle(fontSize: 30),
            ),
            Text(
              'Netflix Subscription',
              style: TextStyle(fontSize: 20, color: Colors.redAccent),
            ),
            SizedBox(height: 15),
            Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), border: Border.all(width: 2)),
                child: Text(
                  'Entertainment',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                )),
            SizedBox(height: 15),
            Divider(
              height: 15,
              thickness: 6,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Details', style: TextStyle(fontSize: 20,)),
                  Text('25-Jun-2020'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
