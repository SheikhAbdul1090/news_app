import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:news_app/models/news_article_model.dart';

class NewsProvider with ChangeNotifier {
  final List<NewsArticleModel> _newsArticles = [];
  bool _loading = false;

  List<NewsArticleModel> get newsArticles => _newsArticles;

  bool get loading => _loading;

  Future<void> getNews(String country) async {
    _loading = true;
    try {
      String url =
          'https://newsapi.org/v2/everything?country=$country&q=tesla&from=2024-01-26&sortBy=publishedAt&apiKey=2a3331676a25413b8903b87cde6fa61b';
      var response = await http.get(Uri.parse(url));
      var jsonData = jsonDecode(response.body);
      if (jsonData['status'] == 'ok') {
        jsonData['articles'].forEach((element) {
          if (element['urlToImage'] != null && element['description'] != null) {
            var newArticleModel = NewsArticleModel.fromJson(element);
            _newsArticles.add(newArticleModel);
          }
        });
      } else {
        _newsArticles.clear();
        Fluttertoast.showToast(
            msg: 'Failed to load data: ${jsonData['status']}');
      }
    } on SocketException {
      _newsArticles.clear();
      Fluttertoast.showToast(msg: 'No internet connection');
    } on TimeoutException {
      _newsArticles.clear();
      Fluttertoast.showToast(msg: 'Request timed out');
    } on HttpException catch (e) {
      _newsArticles.clear();
      Fluttertoast.showToast(msg: 'HTTP error: ${e.message}');
    } on FormatException {
      _newsArticles.clear();
      Fluttertoast.showToast(msg: 'Invalid response format');
    } on ClientException catch (e) {
      _newsArticles.clear();
      Fluttertoast.showToast(msg: 'Client error: ${e.message}');
    } on HandshakeException {
      _newsArticles.clear();
      Fluttertoast.showToast(msg: 'SSL handshake failed');
    } catch (e) {
      _newsArticles.clear();
      Fluttertoast.showToast(msg: 'Unexpected error: $e');
    }
    notifyListeners();
    _loading = false;
  }
}
