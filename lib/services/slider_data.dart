import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/models/slider_model.dart';

class Sliders {
  List<SliderModel> sliders = [];

  Future<void> getAllSlidersData() async {
    String url =
        'https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=2a3331676a25413b8903b87cde6fa61b';
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);
    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          SliderModel sliderModel = SliderModel(
            author: element['author'],
            title: element['title'],
            description: element['description'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            content: element['content'],
          );
          sliders.add(sliderModel);
        }
      });
    } else {
      print('Something went wrong');
    }
  }
}
