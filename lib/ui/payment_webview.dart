import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/ui/receipt/payment_receipt.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentOnlineScreen extends StatefulWidget {
  final String bank;

  const PaymentOnlineScreen({Key? key, required this.bank}) : super(key: key);

  @override
  State<PaymentOnlineScreen> createState() => _PaymentOnlineScreenState();
}

class _PaymentOnlineScreenState extends State<PaymentOnlineScreen> {
  late final WebViewController _controller;
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.bank))
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          debugPrint("url: $url");
          final uri = Uri.parse(url);
          if (uri.pathSegments.contains("checkout") &&
              uri.host == "7learn.com") {
            final orderId = int.parse(uri.queryParameters['order_id']!);
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PaymentReceiptScreen(orderId: orderId)));
          } else {
            final orderId = int.parse(uri.queryParameters['order_id']!);
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PaymentReceiptScreen(orderId: orderId)));
          }
        },
        // ));
        // onNavigationRequest: (request) {
        //   final uri = Uri.parse(request.url);
        //   if (uri.pathSegments.contains("checkout") &&
        //       uri.host == "fapi.7learn.com") {
        //     final orderId = int.parse(uri.queryParameters['order_id']!);
        //     Navigator.of(context).pop();
        //     Navigator.of(context).push(MaterialPageRoute(
        //         builder: (context) => PaymentScreen(orderId: orderId)));
        //     return NavigationDecision.prevent;
        //   }
        //   return NavigationDecision.navigate;
        // },
      ));
  }

  @override
  Widget build(BuildContext context) {
    return
        //  WebView(
        //   initialUrl: widget.bank,
        //   javascriptMode: JavascriptMode.unrestricted,
        //   onPageStarted: (url) {
        //     debugPrint("url: $url");
        //     final uri = Uri.parse(url);
        //     if (uri.pathSegments.contains("checkout") &&
        //         uri.host == "fapi.7learn.com") {
        //       final orderId = int.parse(uri.queryParameters['order_id']!);
        //       Navigator.of(context).pop();
        //       Navigator.of(context).push(MaterialPageRoute(
        //           builder: (context) => PaymentScreen(orderId: orderId)));
        //     }
        //   },
        // );
        WebViewWidget(
      controller: _controller,
    );

    // Container();
  }
}
