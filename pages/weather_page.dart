import 'package:flutter/material.dart';
import 'package:weerapp/services/weather_service.dart';
import '../models/weather_model.dart';
import 'package:lottie/lottie.dart';


class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  // api key
  final _weatherService = WeatherService('f156be00b9c8bfb362daa8a2a4727f9b');
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    // any errors
    catch (e) {
      print(e);
    }
  }

    // weather animations
  String getWeatherAnimation(String? mainCondition){
    if (mainCondition ==  null) return 'assets/sunny.json'; // default to sunny

    switch(mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      case 'snow':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/cloud.rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }


  //init state
  @override
  void initState() {
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[600],
      appBar: AppBar(centerTitle: true,
      title: const Text(
          "Goeden morgen😀", style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white),
      ),
        backgroundColor: Colors.cyan[600],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // city name
            Text(_weather?.cityName ?? "Loading city..", style: TextStyle(color: Colors.white) ,),

            // animations
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            // temperature
            Text('${_weather?.temperature.round()}°C', style: TextStyle(color: Colors.white),),

            // weather condition
            Text(_weather?.mainCondition ?? "",style: TextStyle(color: Colors.white),)
          ],
        ),
      ),
    );
  }
}
