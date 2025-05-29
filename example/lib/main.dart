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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const PlacesAutocompleteScreen(),
    );
  }
}

class PlacesAutocompleteScreen extends StatefulWidget {
  const PlacesAutocompleteScreen({super.key});

  @override
  PlacesAutocompleteScreenState createState() =>
      PlacesAutocompleteScreenState();
}

class PlacesAutocompleteScreenState extends State<PlacesAutocompleteScreen> {
  final TextEditingController _searchController = TextEditingController();

  /// The Google Places API key (replace with your actual API key).
  final String _apiKey = "YOUR_API_KEY";

  /// The autocomplete service instance.
  late GooglePlacesAutocomplete _placesService;

  /// List to store predictions for display.
  List<Prediction> _predictions = [];

  /// Tracks the loading state of predictions
  bool _isPredictionLoading = false;

  /// Details of the selected place.
  PlaceDetails? _placeDetails;

  /// Tracks the loading state of place details
  bool _isDetailsLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize the GooglePlacesAutocomplete service.
    _placesService = GooglePlacesAutocomplete(
      apiKey: _apiKey,
      debounceTime: 300,
      countries: ['us', 'ca'], // Optional: Filter by countries
      language: 'en', // Optional: Set language
      predictionsListner: (predictions) {
        setState(() {
          _predictions = predictions;
        });
      },
      loadingListner: (isPredictionLoading) {
        setState(() {
          _isPredictionLoading = isPredictionLoading;
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
    if (!mounted) return;

    setState(() {
      _isDetailsLoading = true;
    });

    try {
      final details = await _placesService.getPredictionDetail(placeId);
      if (!mounted) return;

      setState(() {
        _placeDetails = details;
      });
    } catch (e) {
      if (!mounted) return;

      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching place details: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isDetailsLoading = false;
      });
    }
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
              decoration: InputDecoration(
                hintText: 'Search for a place',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _predictions = [];
                          });
                        },
                      )
                    : _isPredictionLoading
                        ? Transform.scale(
                            scale: 0.5,
                            child: const CircularProgressIndicator(),
                          )
                        : null,
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
            const SizedBox(height: 16),

            // Search results
            Expanded(
              child: _predictions.isEmpty
                  ? Center(
                      child: Text(
                        _searchController.text.isEmpty
                            ? 'Start typing to search for places'
                            : 'No results found',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _predictions.length,
                      itemBuilder: (context, index) {
                        final prediction = _predictions[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(
                                _getIconForType(
                                    prediction.types?.firstOrNull ?? ''),
                                size: 18,
                              ),
                            ),
                            title: Text(prediction.description ?? ''),
                            subtitle: Text(prediction
                                    .structuredFormatting?.secondaryText ??
                                ''),
                            onTap: () {
                              _fetchPlaceDetails(prediction.placeId ?? '');
                            },
                          ),
                        );
                      },
                    ),
            ),

            // Display selected place details
            if (_placeDetails != null) ...[
              const Divider(),
              const Text(
                'Place Details:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              _isDetailsLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildPlaceDetailsCard(_placeDetails!),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds the card to display place details
  Widget _buildPlaceDetailsCard(PlaceDetails details) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              details.name ?? 'Unknown Location',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child:
                      Text(details.formattedAddress ?? 'Address not available'),
                ),
              ],
            ),
            if (details.formattedPhoneNumber != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.phone, color: Colors.green, size: 16),
                  const SizedBox(width: 4),
                  Text(details.formattedPhoneNumber!),
                ],
              ),
            ],
            if (details.website != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.language, color: Colors.blue, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                      child: Text(details.website!,
                          overflow: TextOverflow.ellipsis)),
                ],
              ),
            ],
            if (details.rating != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                      '${details.rating} (${details.userRatingsTotal} reviews)'),
                ],
              ),
            ],
            if (details.geometry?.location != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.pin_drop, color: Colors.purple, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Lat: ${details.geometry!.location!.lat}, Lng: ${details.geometry!.location!.lng}',
                    style:
                        const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Returns an appropriate icon based on the place type
  IconData _getIconForType(String type) {
    switch (type) {
      case 'restaurant':
      case 'food':
      case 'cafe':
        return Icons.restaurant;
      case 'store':
      case 'shopping_mall':
      case 'supermarket':
        return Icons.shopping_cart;
      case 'lodging':
      case 'hotel':
        return Icons.hotel;
      case 'hospital':
      case 'doctor':
      case 'pharmacy':
        return Icons.local_hospital;
      case 'airport':
      case 'bus_station':
      case 'train_station':
      case 'transit_station':
        return Icons.directions_transit;
      case 'park':
      case 'natural_feature':
        return Icons.park;
      case 'point_of_interest':
      case 'tourist_attraction':
        return Icons.attractions;
      default:
        return Icons.location_on;
    }
  }
}
