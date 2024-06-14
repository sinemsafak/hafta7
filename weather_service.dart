import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'e25114102fmshd228bf9d890699ep114ba5jsnb3c838600ba2';

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    try {
      final response = await http.get(
        Uri.parse('https://weatherapi-com.p.rapidapi.com/current.json?q=$city'),
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': 'weatherapi-com.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Response data for $city: $data');
        return data;
      } else {
        print('Failed to load weather data for $city. Status code: ${response.statusCode}');
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }
}
