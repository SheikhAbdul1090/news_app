import 'package:flutter/material.dart';
import 'package:news_app/widget/appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleWebView extends StatefulWidget {
  const ArticleWebView(this.newsBlogUrl, {super.key});

  final String newsBlogUrl;

  @override
  State<ArticleWebView> createState() => _ArticleWebViewState();
}

class _ArticleWebViewState extends State<ArticleWebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: WebView(
        initialUrl: widget.newsBlogUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
