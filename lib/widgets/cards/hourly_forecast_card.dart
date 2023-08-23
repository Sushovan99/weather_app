import 'package:flutter/material.dart';
import 'package:weather_app/utils/secrets.dart';

class HourlyForecastCard extends StatelessWidget {
  const HourlyForecastCard(
      {super.key,
      required this.time,
      required this.temperature,
      required this.iconName,
      required this.weatherCondition});

  final String time;
  final String temperature;
  final String iconName;
  final String weatherCondition;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 150,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Image.network(
              '$weatherIconURL/$iconName.png',
              fit: BoxFit.cover,
              height: 50,
            ),
            Text(
              weatherCondition,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(temperature),
          ],
        ),
      ),
    );
  }
}
