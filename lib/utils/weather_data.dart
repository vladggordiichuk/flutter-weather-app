import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'location_helper.dart';

const apiKey = '3940ba34d9bd2fb55aa231eaaa1c887d';

class WeatherData {
  WeatherData({@required this.locationData});

  LocationHelper locationData;
  double currentTemperature;
  int currentCondition;
  String currentCity;

  Future<void> getCurrentTemperature() async {
    Response response = await get(
        'https://api.openweathermap.org/data/2.5/weather?lat=${locationData.latitude}&lon=${locationData.longitude}&appid=${apiKey}&units=metric');

    if (response.statusCode == 200) {
      String data = response.body;

      var currentWeather = jsonDecode(data);

      try {
        currentTemperature = currentWeather['main']['temp'];
        currentCondition = currentWeather['weather'][0]['id'];
        currentCity = currentWeather['name'];
      } catch (e) {
        print(e);
      }
    } else {
      print('Could not fetch temperature!');
    }
  }

  WeatherDisplayData getWeatherDisplayData() {
    if (currentCondition < 600) {
      return WeatherDisplayData(
        weatherIcon: Icon(
          FontAwesomeIcons.cloud,
          size: 75.0,
        ),
        weatherImage: AssetImage('assets/cloud.png'),
      );
    } else {
      var now = new DateTime.now();

      if (now.hour >= 15) {
        return WeatherDisplayData(
          weatherImage: AssetImage('assets/night.png'),
          weatherIcon: Icon(
            FontAwesomeIcons.moon,
            size: 75.0,
            color: Colors.white,
          ),
        );
      } else {
        return WeatherDisplayData(
          weatherIcon: Icon(
            FontAwesomeIcons.sun,
            size: 75.0,
            color: Colors.white,
          ),
          weatherImage: AssetImage('assets/sunny.png'),
        );
      }
    }
  }
}

class WeatherDisplayData {
  Icon weatherIcon;
  AssetImage weatherImage;

  WeatherDisplayData({@required this.weatherIcon, @required this.weatherImage});
}
