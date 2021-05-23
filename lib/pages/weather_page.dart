import 'package:flutter/material.dart';

import 'package:weather_app/utils/weather_data.dart';

import 'loading_page.dart';

class WeatherPage extends StatefulWidget {
  WeatherPage({@required this.weatherData}); // constructor

  final WeatherData weatherData;

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  int temperature;
  String cityName;
  Icon weatherDisplayIcon;
  AssetImage backgroundImage;

  void updateDisplayInfo(WeatherData weatherData) {
    setState(() {
      temperature = weatherData.currentTemperature.round();
      cityName = weatherData.currentCity;

      WeatherDisplayData weatherDisplayData =
          weatherData.getWeatherDisplayData();

      backgroundImage = weatherDisplayData.weatherImage;
      weatherDisplayIcon = weatherDisplayData.weatherIcon;
    });
  }

  @override
  void initState() {
    super.initState();

    updateDisplayInfo(widget.weatherData);
  }

  _refreshAction() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LoadingPage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(image: backgroundImage, fit: BoxFit.cover),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Container(
                  child: weatherDisplayIcon,
                ),
                SizedBox(height: 15.0),
                Center(
                  child: Text(
                    " $temperature°",
                    style: TextStyle(
                        color: Colors.white, fontSize: 80.0, letterSpacing: -5),
                  ),
                ),
              ],
            ),
            Row(children: [
              Expanded(
                child: Container(
                  color: Colors.black,
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "$cityName",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              backgroundColor: Colors.black,
                              color: Colors.white,
                              fontSize: 25.0),
                        ),
                      ),
                      FloatingActionButton.extended(
                        onPressed: () {
                          _refreshAction();
                        },
                        label: const Text('Refresh'),
                        icon: const Icon(Icons.refresh),
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
