import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/widgets/cards/additional_info_card.dart';
import 'package:weather_app/widgets/cards/hourly_forecast_card.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

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
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: Column(
                          children: [
                            Text(
                              '300.67K',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.cloud,
                              size: 60,
                            ),
                            Text(
                              'Rain',
                              style: TextStyle(
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
                'Weather Forecast',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    HourlyForecastCard(
                      icon: Icons.cloud,
                      time: '09:30',
                      temperature: '300.22',
                    ),
                    HourlyForecastCard(
                      icon: Icons.sunny,
                      time: '09:30',
                      temperature: '312.77',
                    ),
                    HourlyForecastCard(
                      icon: Icons.cloud,
                      time: '09:30',
                      temperature: '300.77',
                    ),
                    HourlyForecastCard(
                      icon: Icons.thunderstorm,
                      time: '09:30',
                      temperature: '300',
                    )
                  ],
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfoCard(
                    icon: Icons.water_drop,
                    cardText: 'Humidity',
                    label: 94,
                  ),
                  AdditionalInfoCard(
                    icon: Icons.air,
                    cardText: 'Wind Speed',
                    label: 7.67,
                  ),
                  AdditionalInfoCard(
                    icon: Icons.beach_access,
                    cardText: 'Pressure',
                    label: 1006,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
