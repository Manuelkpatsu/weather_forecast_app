import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'repository/weather_repository.dart';
import 'store/weather_store.dart';
import 'weather_search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => WeatherStore(FakeWeatherRepository()),
      child: Consumer<WeatherStore>(
        builder: (_, store, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: WeatherSearchPage(store),
          );
        },
      ),
    );
  }
}
