import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/utils/secrets.dart';
import 'package:weather_app/widgets/cards/additional_info_card.dart';
import 'package:weather_app/widgets/cards/hourly_forecast_card.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final String city = "Kolkata";
  final String country = "india";
  late Future<Map<String, dynamic>> weather;

  Future<Map<String, dynamic>> getWeatherReport() async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$city,$country&APPID=$appID',
        ),
      );

      final data = jsonDecode(res.body);

      if (data['cod'] != "200") {
        throw "An unexpected error occured";
      }

      return data;
    } catch (error) {
      throw error.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getWeatherReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            fontSize: 20.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getWeatherReport();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 45,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    snapshot.error.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data!;
          final Map<String, dynamic> currentWeatherData = data['list'][0];
          final currentTemp = currentWeatherData['main']['temp'];
          final currentWeather = currentWeatherData['weather'][0];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currenthumidity = currentWeatherData['main']['humidity'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final List hourlyData = data['list'];

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${country[0].toUpperCase() + country.substring(1)}, $city',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${(currentTemp - 273.15).toStringAsFixed(2)}°C',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Image.network(
                                '$weatherIconURL/${currentWeather['icon']}.png',
                              ),
                              Text(
                                currentWeather['main'],
                                style: const TextStyle(
                                  fontSize: 17.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Hourly Forecast',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),

                /// SingleChildScrollView is useful for complex layout with small number of items.
                // const SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       HourlyForecastCard(
                //         icon: Icons.cloud,
                //         time: '09:30',
                //         temperature: '300.22',
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      final DateTime time =
                          DateTime.parse(hourlyData[index]['dt_txt']);
                      final temp = hourlyData[index + 1]['main']['temp'];
                      final String iconName =
                          hourlyData[index + 1]['weather'][0]['icon'];
                      final String weatherCondition =
                          hourlyData[index + 1]['weather'][0]['main'];

                      return HourlyForecastCard(
                        time: DateFormat.j().format(time),
                        temperature: "${(temp - 273.15).toStringAsFixed(2)}°C",
                        iconName: iconName,
                        weatherCondition: weatherCondition,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Additional Information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoCard(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: "$currenthumidity",
                    ),
                    AdditionalInfoCard(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: "$currentWindSpeed",
                    ),
                    AdditionalInfoCard(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: "$currentPressure",
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
