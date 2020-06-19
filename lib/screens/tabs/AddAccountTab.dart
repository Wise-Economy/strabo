import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/AppState.dart';
import '../../blocs/Connections.dart';
import '../../models/json/ConnectionData.dart';

import '../SaltEdgeScreen.dart';

import '../../common/widgets/progress.dart';

class AddAccountTab extends StatefulWidget {
  @override
  _AddAccountTabState createState() => _AddAccountTabState();
}

class _AddAccountTabState extends State<AddAccountTab> {
  Connections _connections;

  @override
  void initState() {
    super.initState();
    _connections = Provider.of<AppState>(context, listen: false).connections;
    _connections.fetchConnections();
  }

  Future<void> _showProgress() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return progress();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<ConnectionData>>(
          stream: _connections.connections,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.network(
                      'https://d1uuj3mi6rzwpm.cloudfront.net/logos/providers/xf/placeholder_global.svg',
                      height: 100,
                      width: 100,
                    ),
                    Text(
                      'No Accounts added yet',
                    )
                  ],
                ),
              );
            }
            if (snapshot.hasData) {
              List<ConnectionData> _connections = snapshot.data;
              if (_connections.length == 0) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.network(
                        'https://d1uuj3mi6rzwpm.cloudfront.net/logos/providers/xf/placeholder_global.svg',
                        height: 100,
                        width: 100,
                      ),
                      Text(
                        'No Banks added yet',
                      )
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: _connections.length,
                itemBuilder: (context, index) {
                  ConnectionData connectionData = _connections[index];
                  return ListTile(
                    onTap: () {},
                    leading: SvgPicture.network(
                      'https://d1uuj3mi6rzwpm.cloudfront.net/logos/providers/xf/placeholder_global.svg',
                      height: 40,
                      width: 40,
                    ),
                    title: Text('${connectionData.providerName}'),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showProgress();
          String connectURL = await _connections.fetchConnectSession();
          Navigator.of(context).pop();
          if (connectURL != null) {
            print('connectUrl:$connectURL');
          }
          bool refresh = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => SaltEdgeScreen(connectURL: connectURL)));
          if (refresh) {
            _connections.fetchConnections();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddBank extends StatefulWidget {
  @override
  _AddBankState createState() => _AddBankState();
}

class _AddBankState extends State<AddBank> {
  final _connections = Connections();

  @override
  void initState() {
    super.initState();
    _connections.fetchConnections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bank'),
//        actions: <Widget>[
//          IconButton(
//              onPressed: () {
//                showSearch(context: context, delegate: BankSearch(banks.last));
//              },
//              icon: Icon(Icons.search))
//        ],
      ),
      body: SafeArea(
        child: StreamBuilder<List<ConnectionData>>(
          stream: _connections.connections,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ConnectionData> _connections = snapshot.data;
              return ListView.builder(
                itemCount: _connections.length,
                itemBuilder: (context, index) {
                  ConnectionData connectionData = _connections[index];
                  return ListTile(
                    onTap: () {},
                    leading: SvgPicture.network(
                      'https://d1uuj3mi6rzwpm.cloudfront.net/logos/providers/xf/placeholder_global.svg',
                      height: 40,
                      width: 40,
                    ),
                    title: Text('${connectionData.providerName}'),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _connections.dispose();
    super.dispose();
  }
}

class BankSearch extends SearchDelegate<String> {
  List<ConnectionData> _banks;

  BankSearch(this._banks);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.close),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredProviders = _banks.where((element) => element.providerName.toLowerCase().startsWith(query)).toList();
    return ListView.builder(
      itemCount: filteredProviders.length,
      itemBuilder: (context, index) {
        ConnectionData provider = filteredProviders[index];
        return ListTile(
          onTap: () {},
          leading: SvgPicture.network(
            'https://d1uuj3mi6rzwpm.cloudfront.net/logos/providers/xf/placeholder_global.svg',
            height: 40,
            width: 40,
          ),
          title: Text('${provider.providerName}'),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredProviders = _banks.where((element) => element.providerName.toLowerCase().startsWith(query)).toList();
    return ListView.builder(
      itemCount: filteredProviders.length,
      itemBuilder: (context, index) {
        ConnectionData provider = filteredProviders[index];
        return ListTile(
          onTap: () {},
          leading: SvgPicture.network(
            'https://d1uuj3mi6rzwpm.cloudfront.net/logos/providers/xf/placeholder_global.svg',
            height: 40,
            width: 40,
          ),
          title: Text('${provider.providerName}'),
        );
      },
    );
  }
}


