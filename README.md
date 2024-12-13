# Google Places Autocomplete

![Flutter 3.24.4](https://img.shields.io/badge/Flutter-3.24.4-blue)
[![pub package](https://img.shields.io/pub/v/google_places_autocomplete.svg?label=google_places_autocomplete&color=blue)](https://pub.dev/packages/google_places_autocomplete)

### Google Places Autocomplete is a Flutter package for integrating Google Places(new) API into your app. This package enables autocomplete suggestions, detailed place information retrieval, and more. It simplifies working with the Google Places API in Flutter projects.

Google Places Autocomplete is a comprehensive Flutter package that facilitates seamless integration of the new Google Places API into your app. It empowers developers to provide rich, location-based features such as autocomplete suggestions, detailed place information retrieval, and interactive maps.

With this package, users can easily search for locations using Google’s powerful Places Autocomplete API. The package supports advanced features like filtering results by country, type, or language, and includes debounce functionality to ensure a smooth user experience by reducing unnecessary API calls. Additionally, it enables fetching detailed place information, including addresses, geographical coordinates, phone numbers, and more.

Designed with developers in mind, the package simplifies complex interactions with the Google Places API through a clean, modular structure. It integrates seamlessly with Flutter UI components, and works well alongside `google_maps_flutter` for displaying maps and location data. Whether you’re building a travel app, a delivery service, or any location-aware app, this package offers a robust, flexible solution to meet your needs.

With detailed documentation, examples, and customization options, Google Places Autocomplete provides everything you need to deliver accurate, location-based functionality in your Flutter applications.

## Features

- Autocomplete search with suggestions and predictions.
- Fetch detailed place information (address, phone numbers, coordinates, etc.).
- Support for filtering by country, place type, and language.
- Debounce functionality to improve performance and UX.
- Integration with `google_maps_flutter` for seamless map interactions.

## Getting Started

### Prerequisites

To use this package, you need:

1. A Google Cloud Platform project with the **Places API(new)** enabled.
2. An API key for accessing the Places API. You can obtain an API key by following the [Google API Documentation](https://developers.google.com/maps/documentation/places/web-service/get-api-key).

### Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  google_places_autocomplete: latest_version
```

Then, run:

```bash
flutter pub get
```

## Usage

### Basic Setup

- Import the package:

```dart
import 'package:google_places_autocomplete/google_places_autocomplete.dart';
```

- Initialize the service:

```dart
final googlePlaces = GooglePlacesAutocomplete(
  apiKey: "YOUR_API_KEY",
  predictionsListner: (predictions) {
    // Handle predictions
  },
  debounceTime: 300, // Customize debounce time
  countries: ['us'], // Restrict to the US
  primaryTypes: ['locality'], // Focus on specific types
);

googlePlaces.initialize();

```

- Get predictions:

```dart
googlePlaces.getPredictions("San Francisco");
```

or you can pass it directly to onChanged parameter of TextFields

```dart
TextFormField(
    controller: textEditingController,
    focusNode: focusNode,
    onChanged:googlePlaces.getPredictions,
)
```
- Get place details:

```dart
final placeDetails = await googlePlaces.getPredictionDetail("PLACE_ID");
print(placeDetails?.formattedAddress);
```

### Example

Below is an example of integrating Google Places Autocomplete with a Flutter TextField widget:

```dart
import 'package:flutter/material.dart';
import 'package:google_places_autocomplete/google_places_autocomplete.dart';

class PlaceSearchScreen extends StatefulWidget {
  @override
  _PlaceSearchScreenState createState() => _PlaceSearchScreenState();
}

class _PlaceSearchScreenState extends State<PlaceSearchScreen> {
  late final GooglePlacesAutocomplete _placesAutocomplete;

  @override
  void initState() {
    super.initState();
    _placesAutocomplete = GooglePlacesAutocomplete(
      apiKey: "YOUR_API_KEY",
      predictionsListner: (predictions) {
        // Handle predictions and update UI
      },
    );
    _placesAutocomplete.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Places")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Search Location"),
              onChanged: (value) => _placesAutocomplete.getPredictions(value),
            ),
            // Add widgets to display predictions and handle interactions
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _placesAutocomplete.dispose();
    super.dispose();
  }
}

```

## API Reference
### GooglePlacesAutocomplete Constructor
```dart
GooglePlacesAutocomplete({
  required String apiKey,
  required ListenerAutoCompletePredictions predictionsListner,
  int debounceTime = 300,
  List<String>? countries,
  List<String>? primaryTypes,
  String? language,
});
```


## Support

Feel free to file issues on the [GitHub](https://github.com/Cuboid-Inc/google_places_autocomplete) repository for:

- Adding support for additional email apps.
- Reporting bugs or suggesting improvements.

## Contributors

<table>
  <tr>
   <td align="center"><a href="https://github.com/mrcse"><img src="https://avatars.githubusercontent.com/u/73348512?v=4" width="100px;" alt=""/><br /><sub><b>Jamshid Ali</b></sub></a><br /><a href="https://github.com/mrcse" title="Code">💻</a></td>
  <td align="center"><a href="https://github.com/Mubashir-Saeed1"><img src="https://avatars.githubusercontent.com/u/58908265?v=4" width="100px;" alt=""/><br /><sub><b>Mubashir Saeed</b></sub></a><br />
  <a href="https://github.com/Mubashir-Saeed1" title="Code">💻</a></td>

  </tr>
</table>

## License

This package is distributed under the MIT License. See the [LICENSE](https://raw.githubusercontent.com/Cuboid-Inc/google_places_autocomplete/main/LICENSE) file for details.