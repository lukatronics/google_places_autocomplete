import 'package:flutter/material.dart';
import 'package:google_places_autocomplete/google_places_autocomplete.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Google Places Autocomplete Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PlacesAutocompleteScreen(),
    );
  }
}

class PlacesAutocompleteScreen extends StatefulWidget {
  const PlacesAutocompleteScreen({super.key});

  @override
  _PlacesAutocompleteScreenState createState() =>
      _PlacesAutocompleteScreenState();
}

class _PlacesAutocompleteScreenState extends State<PlacesAutocompleteScreen> {
  final TextEditingController _searchController = TextEditingController();

  /// The Google Places API key (replace with your actual API key).
  final String _apiKey = 'GOOGLE_PLACES_API_KEY';

  /// The autocomplete service instance.
  late GooglePlacesAutocomplete _placesService;

  /// List to store predictions for display.
  List<Prediction> _predictions = [];

  /// Details of the selected place.
  PlaceDetails? _placeDetails;

  @override
  void initState() {
    super.initState();

    // Initialize the GooglePlacesAutocomplete service.
    _placesService = GooglePlacesAutocomplete(
      apiKey: _apiKey,
      debounceTime: 300,
      predictionsListner: (predictions) {
        setState(() {
          _predictions = predictions;
        });
      },
    );

    // Start the service.
    _placesService.initialize();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Fetches details of the selected place using its placeId.
  Future<void> _fetchPlaceDetails(String placeId) async {
    final details = await _placesService.getPredictionDetail(placeId);
    setState(() {
      _placeDetails = details;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Places Autocomplete'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search input field
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search for a place',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // Fetch predictions as the user types.
                _placesService.getPredictions(value);
              },
            ),
            const SizedBox(height: 16),

            // Display predictions
            Expanded(
              child: ListView.builder(
                itemCount: _predictions.length,
                itemBuilder: (context, index) {
                  final prediction = _predictions[index];
                  return ListTile(
                    title: Text('${prediction.title}'),
                    subtitle: Text('${prediction.description}'),
                    onTap: () {
                      // Fetch place details when a prediction is tapped.
                      if (prediction.placeId != null) {
                        _fetchPlaceDetails(prediction.placeId!);
                      }
                    },
                  );
                },
              ),
            ),

            // Display place details if available
            if (_placeDetails != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Card(
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_placeDetails!.formattedAddress != null)
                          Text("Address: ${_placeDetails!.formattedAddress!}"),
                        if (_placeDetails!.nationalPhoneNumber != null)
                          Text("Phone: ${_placeDetails!.nationalPhoneNumber!}"),
                        if (_placeDetails!.location != null)
                          Text("Location: ${_placeDetails!.location!.toMap()}"),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
