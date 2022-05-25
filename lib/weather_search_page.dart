import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import 'model/weather.dart';
import 'store/weather_store.dart';

class WeatherSearchPage extends StatelessWidget {
  final WeatherStore weatherStore;

  const WeatherSearchPage(this.weatherStore, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: ReactionBuilder(
        builder: (context) {
          return reaction((_) => weatherStore.errorMessage, (String? message) {
            final messenger = ScaffoldMessenger.of(context);

            messenger.showSnackBar(SnackBar(content: Text(message!)));
          });
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Weather Search"),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.center,
            child: Observer(
              builder: (_) {
                switch (weatherStore.state) {
                  case StoreState.initial:
                    return buildInitialInput();
                  case StoreState.loading:
                    return buildLoading();
                  case StoreState.loaded:
                    return buildColumnWithData(weatherStore.weather!);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInitialInput() {
    return Center(
      child: cityInputField(),
    );
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Column buildColumnWithData(Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          weather.cityName,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          // Display the temperature with 1 decimal place
          "${weather.temperatureCelsius.toStringAsFixed(1)} °C",
          style: const TextStyle(fontSize: 80),
        ),
        cityInputField(),
      ],
    );
  }

  Widget cityInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onSubmitted: (value) => submitCityName(value),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Enter a city",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }

  void submitCityName(String cityName) {
    weatherStore.getWeather(cityName);
  }
}
