import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'weather_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WeatherProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search box
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Enter city name',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () =>
                      context.read<WeatherProvider>().fetchWeather(controller.text),
                ),
              ),
              onSubmitted: (value) =>
                  context.read<WeatherProvider>().fetchWeather(value),
            ),
            const SizedBox(height: 24),

            // Loading / error / result
            if (provider.isLoading)
              const CircularProgressIndicator()
            else if (provider.error != null)
              Text(provider.error!, style: const TextStyle(color: Colors.red))
            else if (provider.weather != null) ...[
              Lottie.asset(provider.weather!.animation, height: 200),
              Text(
                provider.weather!.city,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Text(
                '${provider.weather!.temperature}°C',
                style: const TextStyle(fontSize: 48),
              ),
              Text(
                provider.weather!.description,
                style: const TextStyle(fontSize: 20),
              ),
              Text('Humidity: ${provider.weather!.humidity}%'),
              Text('Wind: ${provider.weather!.windSpeed} m/s'),
            ] else
              const Text('Search a city to see the weather'),
          ],
        ),
      ),
    );
  }
}