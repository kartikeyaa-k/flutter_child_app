import 'package:child_app/core/mock_data/mock_parsed_countries.dart';
import 'package:child_app/core/mock_model/mock_country_with_cities_model.dart';
import 'package:flutter/material.dart';

class CitiesScreen extends StatefulWidget {
  final String countryName;
  const CitiesScreen({
    super.key,
    required this.countryName,
  });

  @override
  State<CitiesScreen> createState() => _CitiesScreenState();
}

class _CitiesScreenState extends State<CitiesScreen> {
  CountryWithCitiesModel? countryWithCities;

  @override
  void initState() {
    super.initState();

    countryWithCities = countriesWithCitiesData.firstWhere(
      (element) =>
          element.countryName.toLowerCase() == widget.countryName.toLowerCase(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cities of ${widget.countryName}')),
      body: countryWithCities == null
          ? Text('No cities found for ${widget.countryName}')
          : ListView.builder(
              itemCount: countryWithCities!.cities.length,
              itemBuilder: (_, index) {
                return ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(
                    countryWithCities!.cities[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
    );
  }
}
