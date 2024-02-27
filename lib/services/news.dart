import 'dart:convert';

import '../models/news_article_model.dart';
import 'package:http/http.dart' as http;

class News {
  List<NewsArticleModel> newsArticles = [];

  Future<void> getNews() async {
    String url =
        'https://newsapi.org/v2/everything?q=tesla&from=2024-01-26&sortBy=publishedAt&apiKey=2a3331676a25413b8903b87cde6fa61b';
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          NewsArticleModel newsArticleModel = NewsArticleModel(
            author: element['author'],
            title: element['title'],
            description: element['description'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            content: element['content'],
          );
          newsArticles.add(newsArticleModel);
        }
      });
    }else{
      print('Something went wrong');
    }
  }
}
