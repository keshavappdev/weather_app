import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model.dart';

class WeatherProvider extends ChangeNotifier {
  static const String apiKey = '24f2ad1b560c1b0925c769e47b338134';

  WeatherModel? weather;
  bool isLoading = false;
  String? error;

  Future<void> fetchWeather(String city) async {
    if (city.trim().isEmpty) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=${city.trim()}&appid=$apiKey&units=metric');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        weather = WeatherModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        error = 'City not found';
        weather = null;
      } else {
        error = 'Error ${response.statusCode}. Check your API key.';
        weather = null;
      }
    } catch (e) {
      error = 'No internet or something went wrong.';
      weather = null;
    }

    isLoading = false;
    notifyListeners();
  }
}