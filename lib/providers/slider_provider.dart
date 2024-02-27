import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:news_app/models/slider_model.dart';

class SliderProvider with ChangeNotifier {
  final List<SliderModel> _sliderModels = [];
  bool _loading = false;

  List<SliderModel> get sliderModels => _sliderModels;

  bool get loading => _loading;

  Future<void> getAllSlidersData(String country) async {
    _loading = true;
    try {
      String url =
          'https://newsapi.org/v2/top-headlines?country=$country&sources=techcrunch&apiKey=2a3331676a25413b8903b87cde6fa61b';
      var response = await http.get(Uri.parse(url));
      var jsonData = jsonDecode(response.body);
      if (jsonData['status'] == 'ok') {
        jsonData['articles'].forEach((element) {
          if (element['urlToImage'] != null && element['description'] != null) {
            var sliderModel = SliderModel.fromJson(element);
            _sliderModels.add(sliderModel);
          }
          notifyListeners();
        });
      } else {
        sliderModels.clear();
        Fluttertoast.showToast(
            msg: 'Failed to load data: ${jsonData['status']}');
      }
    } on SocketException {
      _sliderModels.clear();
      Fluttertoast.showToast(msg: 'No internet connection');
    } on TimeoutException {
      _sliderModels.clear();
      Fluttertoast.showToast(msg: 'Request timed out');
    } on HttpException catch (e) {
      _sliderModels.clear();
      Fluttertoast.showToast(msg: 'HTTP error: ${e.message}');
    } on FormatException {
      _sliderModels.clear();
      Fluttertoast.showToast(msg: 'Invalid response format');
    } on ClientException catch (e) {
      _sliderModels.clear();
      Fluttertoast.showToast(msg: 'Client error: ${e.message}');
    } on HandshakeException {
      _sliderModels.clear();
      Fluttertoast.showToast(msg: 'SSL handshake failed');
    } catch (e) {
      _sliderModels.clear();
      Fluttertoast.showToast(msg: 'Unexpected error: $e');
    }
    notifyListeners();
    _loading = false;
  }
}
