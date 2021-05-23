import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather_app/utils/location_helper.dart';
import 'package:weather_app/utils/weather_data.dart';

import 'weather_page.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  LocationHelper locationData;

  Future<bool> getLocationData() async {
    locationData = LocationHelper();
    await locationData.getCurrentLocation();
    if (locationData.latitude == null || locationData.longitude == null) {
      showErrorDialog(context, "Check your location preferances.");
      return false;
    }
    print(locationData.longitude);
    print(locationData.latitude);
    return true;
  }

  void getWeatherData() async {
    if (await getLocationData() == false) {
      return;
    }

    WeatherData weatherData = WeatherData(locationData: locationData);

    await weatherData.getCurrentTemperature();

    if (weatherData.currentTemperature == null ||
        weatherData.currentCondition == null) {
      showErrorDialog(context, "Check your internet connection.");

      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return WeatherPage(
            weatherData: weatherData,
          );
        },
      ),
    );
  }

  showErrorDialog(BuildContext context, String message) {
    Widget okButton = TextButton(
      child: Text("Refresh"),
      onPressed: () {
        Navigator.of(context).pop();
        getWeatherData();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Ooops, something went wrong."),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.cyan, Colors.red],
              ),
            ),
            child: Center(
                child: SpinKitFadingCube(
                    color: Colors.white,
                    size: 30,
                    duration: Duration(milliseconds: 1200)))));
  }
}
