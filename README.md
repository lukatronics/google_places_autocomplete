# Google Places Autocomplete

![Flutter 3.24.4](https://img.shields.io/badge/Flutter-3.24.4-blue)
[![pub package](https://img.shields.io/pub/v/google_places_autocomplete.svg?label=google_places_autocomplete&color=blue)](https://pub.dev/packages/google_places_autocomplete)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

Google Places Autocomplete is a Flutter package that provides seamless integration with the Google Places API. This package enables developers to implement location search functionality with autocomplete suggestions, detailed place information, and more—all while maintaining complete control over the UI.

### Key Features

- **UI-Agnostic Design**: Implement your own custom UI while the package handles data retrieval
- **Autocomplete Search**: Get real-time location suggestions as users type
- **Detailed Place Information**: Access comprehensive place data including addresses, coordinates, phone numbers, and more
- **Cross-Platform Support**: Works on Android, iOS, Web, and desktop platforms
- **Customizable Filtering**: Filter results by country, place type, or language
- **Performance Optimized**: Built-in debounce functionality to reduce unnecessary API calls

## Getting Started

### Prerequisites

To use this package, you need:

1. A Google Cloud Platform project with the **Places API** enabled
2. An API key for accessing the Places API ([Get API Key](https://developers.google.com/maps/documentation/places/web-service/get-api-key))

### Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  google_places_autocomplete: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Setup

Import the package:

```dart
import 'package:google_places_autocomplete/google_places_autocomplete.dart';
```

Initialize the service with required parameters:

```dart
final placesService = GooglePlacesAutocomplete(
  apiKey: 'YOUR_API_KEY',
  predictionsListner: (predictions) {
    // Handle the predictions here
    setState(() {
      _predictions = predictions;
    });
  },
);

// Always initialize the service before use
placesService.initialize();
```

### Fetching Place Predictions

To get autocomplete predictions as the user types:

```dart
// Call this method when the user enters text in the search field
placesService.getPredictions('user input text');
```

### Fetch Place Details

Once a user selects a prediction, you can fetch detailed information about the place:

```dart
final placeDetails = await placesService.getPredictionDetail('PLACE_ID');

// Access various place details
final address = placeDetails.formattedAddress;
final phoneNumber = placeDetails.formattedPhoneNumber;
final location = placeDetails.geometry?.location;
final latitude = location?.lat;
final longitude = location?.lng;
```

### Advanced Configuration

The package supports several configuration options:

```dart
final placesService = GooglePlacesAutocomplete(
  apiKey: 'YOUR_API_KEY',
  debounceTime: 300,  // Milliseconds to wait before making API call (default: 300)
  countries: ['us', 'ca'],  // Restrict results to specific countries
  primaryTypes: ['restaurant', 'cafe'], // Filter results by place types
  language: 'en',  // Specify the language for results
  predictionsListner: (predictions) {
    // Handle predictions
  },
  loadingListner: (isLoading) {
    // Track loading state
  },
);
```

## Example

A complete implementation example showing a search field with autocomplete predictions:

```dart
class PlaceSearchScreen extends StatefulWidget {
  @override
  _PlaceSearchScreenState createState() => _PlaceSearchScreenState();
}

class _PlaceSearchScreenState extends State<PlaceSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final String _apiKey = 'YOUR_API_KEY';
  late GooglePlacesAutocomplete _placesService;
  List<Prediction> _predictions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _placesService = GooglePlacesAutocomplete(
      apiKey: _apiKey,
      predictionsListner: (predictions) {
        setState(() {
          _predictions = predictions;
        });
      },
      loadingListner: (isLoading) {
        setState(() {
          _isLoading = isLoading;
        });
      },
    );
    _placesService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Search for a place',
            suffixIcon: _isLoading 
              ? CircularProgressIndicator() 
              : Icon(Icons.search),
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              _placesService.getPredictions(value);
            } else {
              setState(() {
                _predictions = [];
              });
            }
          },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _predictions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_predictions[index].description ?? ''),
                onTap: () async {
                  final details = await _placesService.getPredictionDetail(
                    _predictions[index].placeId ?? '',
                  );
                  // Do something with the place details
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
```

## Model Classes

The package provides the following model classes:

### Prediction

Represents a place prediction from the Google Places API autocomplete endpoint.

Key properties:
- `description`: The human-readable name of the place
- `placeId`: The ID of the place, which can be used to fetch detailed place information
- `structuredFormatting`: Contains the main text and secondary text for the prediction
- `types`: The types of the predicted place (e.g., 'restaurant', 'establishment')

### PlaceDetails

Represents detailed information about a place.

Key properties:
- `name`: The name of the place
- `formattedAddress`: The complete address of the place
- `formattedPhoneNumber`: The phone number in international format
- `nationalPhoneNumber`: The phone number in local format
- `website`: The website URL
- `rating`: The average rating (out of 5)
- `userRatingsTotal`: Total number of user ratings
- `geometry`: Contains location information (latitude and longitude)

## Platform Support

This package works on:

- Android
- iOS
- Web
- macOS
- Windows
- Linux

## Troubleshooting

### Common Issues

1. **No predictions returned**: Ensure your API key has the Places API enabled and has proper restrictions set.

2. **Web platform issues**: Make sure your API key is properly configured with allowed referrers/domains.

3. **Invalid API key**: Check that your API key is correct and properly formatted.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgements

- Google Places API for providing the location data services
