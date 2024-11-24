import 'dart:convert';
import 'package:final_yearproject/screens/weather/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherServices {
  fetchWeather() async {
    final response = await http.get(
      Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?lat=11.9416&lon=79.8083&appid=d17775226837a9467c26476bc3148c2d"),
    );

    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return WeatherData.fromJson(json);
      } else {
        throw Exception('Failed to load Weather data');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
