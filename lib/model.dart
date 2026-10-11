class WeatherModel {
  final String city;
  final double temperature;
  final double windSpeed;
  final int humidity;
  final int conditionId;
  final String description;

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.conditionId,
    required this.description,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['name'],
      temperature: (json['main']['temp'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      conditionId: json['weather'][0]['id'] as int,
      description: json['weather'][0]['description'],
    );
  }

  // Lottie file based on OpenWeatherMap condition id
  String get animation {
    if (conditionId >= 200 && conditionId < 300) return 'assets/storm.json';
    if (conditionId >= 300 && conditionId < 600) return 'assets/rainy.json';
    if (conditionId == 800) return 'assets/sunny.json';
    return 'assets/cloudy.json';
  }
}