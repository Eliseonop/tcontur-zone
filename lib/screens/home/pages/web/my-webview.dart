import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:tcontur_zone/provider/provider_user.dart';

class ViewWeb extends StatefulWidget {
  const ViewWeb({Key? key}) : super(key: key);

  @override
  ViewWebState createState() => ViewWebState();
}

class ViewWebState extends State<ViewWeb> {
  double progress = 0;
  late InAppWebViewController inAppWebViewController;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final token = userProvider.user?.token;
    print(
        ' TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT ${userProvider.user!.token}');
    final url =
        Uri.parse('https://urbanito.tcontur.pe/verify-token?token=$token');

    print('URL ------- URL----------URL ----------- URL ----------- URL: $url');
    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: url,
      ),
      onWebViewCreated: (InAppWebViewController controller) {
        inAppWebViewController = controller;
      },
      onLoadStart: (InAppWebViewController controller, Uri? url) {
        print('onLoadStart: $url');
      },
      onLoadStop: (InAppWebViewController controller, Uri? url) async {
        print('onLoadStop: $url');
      },
      onProgressChanged: (InAppWebViewController controller, int progress) {
        setState(() {
          this.progress = progress / 100;
        });
      },
    );
  }
}
