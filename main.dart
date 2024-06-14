import 'package:flutter/material.dart';
import 'weather_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  final List<String> _cities = ['Istanbul', 'Ankara', 'Izmir', 'Antalya', 'Bursa'];
  Map<String, dynamic> _weatherData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      for (final city in _cities) {
        final data = await _weatherService.fetchWeather(city);
        print('Weather data for $city: $data');
        setState(() {
          _weatherData[city] = data;
        });
      }
    } catch (e) {
      print('Error fetching weather data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _cities.length,
        itemBuilder: (context, index) {
          final city = _cities[index];
          final weather = _weatherData[city];
          return weather != null
              ? Card(
            margin: EdgeInsets.all(10.0),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location: $city',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text('Temperature: ${weather['current']['temp_c']}°C'),
                  Text('Humidity: ${weather['current']['humidity']}%'),
                  Text('Wind speed: ${weather['current']['wind_kph']} km/h'),
                ],
              ),
            ),
          )
              : Center(child: Text('No data available for $city'));
        },
      ),
    );
  }
}
