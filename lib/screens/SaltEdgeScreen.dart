import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class SaltEdgeScreen extends StatefulWidget {
  final String connectURL;

  SaltEdgeScreen({@required this.connectURL});

  @override
  _SaltEdgeScreenState createState() => _SaltEdgeScreenState();
}

class _SaltEdgeScreenState extends State<SaltEdgeScreen> {
  final _key = UniqueKey();
  int _stackToView = 1;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Bank'),
        ),
        body: SafeArea(
          child: IndexedStack(
            index: _stackToView,
            children: [
              Column(
                children: <Widget>[
                  Expanded(
                    child: WebView(
                      key: _key,
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: '${widget.connectURL}',
                      navigationDelegate: (NavigationRequest request) {
                        print('RequestURL:${request.url}');
                        if (request.url.contains('connection_id')) {
                          Navigator.pop(context, true);
                          return NavigationDecision.prevent;
                        }
                        return NavigationDecision.navigate;
                      },
                      onPageFinished: _handleLoad,
                    ),
                  ),
                ],
              ),
              Container(
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}