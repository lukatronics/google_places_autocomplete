/// Represents the detailed information about a place fetched from the Google Places API.
class PlaceDetails {
  /// The national format phone number of the place.
  final String? nationalPhoneNumber;

  /// The international format phone number of the place.
  final String? internationalPhoneNumber;

  /// The formatted address of the place.
  final String? formattedAddress;

  /// The street address of the place (e.g., "Main St").
  final String? streetAddress;

  /// The street number of the place (e.g., "123").
  final String? streetNumber;

  /// The city where the place is located.
  final String? city;

  /// The state or province where the place is located.
  final String? state;

  /// The region or administrative area where the place is located.
  final String? region;

  /// The postal or zip code of the place.
  final String? zipCode;

  /// The country where the place is located.
  final String? country;

  /// The geographical location (latitude and longitude) of the place.
  final PlaceLocation? location;

  /// The Google Maps URL for the place.
  final String? googleMapsUri;

  /// The website URL associated with the place.
  final String? websiteUri;

  /// Constructor for creating a [PlaceDetails] instance.
  PlaceDetails({
    this.nationalPhoneNumber,
    this.internationalPhoneNumber,
    this.formattedAddress,
    this.streetAddress,
    this.streetNumber,
    this.city,
    this.state,
    this.region,
    this.zipCode,
    this.country,
    this.location,
    this.googleMapsUri,
    this.websiteUri,
  });

  /// Creates a copy of the [PlaceDetails] instance with updated values.
  ///
  /// If a value is not provided, the existing value is retained.
  PlaceDetails copyWith({
    String? nationalPhoneNumber,
    String? internationalPhoneNumber,
    String? formattedAddress,
    String? streetAddress,
    String? streetNumber,
    String? city,
    String? state,
    String? region,
    String? zipCode,
    String? country,
    PlaceLocation? location,
    String? googleMapsUri,
    String? websiteUri,
  }) {
    return PlaceDetails(
      nationalPhoneNumber: nationalPhoneNumber ?? this.nationalPhoneNumber,
      internationalPhoneNumber:
          internationalPhoneNumber ?? this.internationalPhoneNumber,
      formattedAddress: formattedAddress ?? this.formattedAddress,
      streetAddress: streetAddress ?? this.streetAddress,
      streetNumber: streetNumber ?? this.streetNumber,
      city: city ?? this.city,
      state: state ?? this.state,
      region: region ?? this.region,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      location: location ?? this.location,
      googleMapsUri: googleMapsUri ?? this.googleMapsUri,
      websiteUri: websiteUri ?? this.websiteUri,
    );
  }

  /// Converts the [PlaceDetails] instance into a map representation.
  Map<String, dynamic> toMap() {
    return {
      'nationalPhoneNumber': nationalPhoneNumber,
      'internationalPhoneNumber': internationalPhoneNumber,
      'formattedAddress': formattedAddress,
      'streetAddress': streetAddress,
      'streetNumber': streetNumber,
      'city': city,
      'state': state,
      'region': region,
      'zipCode': zipCode,
      'country': country,
      'location': location?.toMap(),
      'googleMapsUri': googleMapsUri,
      'websiteUri': websiteUri,
    };
  }

  /// Creates a [PlaceDetails] instance from a map.
  ///
  /// The map should be fetched from a Google Places API response.
  factory PlaceDetails.fromMap(Map<dynamic, dynamic> map) {
    String? extractAddressComponent(List<dynamic> components, String type) {
      for (var component in components) {
        if ((component['types'] as List).contains(type)) {
          return component['longText'];
        }
      }
      return null;
    }

    return PlaceDetails(
      nationalPhoneNumber: map['nationalPhoneNumber'],
      internationalPhoneNumber: map['internationalPhoneNumber'],
      formattedAddress: map['formattedAddress'],
      streetAddress: extractAddressComponent(map['addressComponents'], 'route'),
      streetNumber:
          extractAddressComponent(map['addressComponents'], 'street_number'),
      city: extractAddressComponent(map['addressComponents'], 'locality'),
      state: extractAddressComponent(
          map['addressComponents'], 'administrative_area_level_1'),
      region: extractAddressComponent(
          map['addressComponents'], 'administrative_area_level_2'),
      zipCode: extractAddressComponent(map['addressComponents'], 'postal_code'),
      country: extractAddressComponent(map['addressComponents'], 'country'),
      location: map['location'] != null
          ? PlaceLocation.fromMap(map['location'] as Map<String, dynamic>)
          : null,
      googleMapsUri:
          map['googleMapsUri'] != null ? map['googleMapsUri'] as String : null,
      websiteUri:
          map['websiteUri'] != null ? map['websiteUri'] as String : null,
    );
  }
}

/// Represents the geographical location of a place.
class PlaceLocation {
  /// The latitude of the location.
  final double latitude;

  /// The longitude of the location.
  final double longitude;

  /// Constructor for creating a [PlaceLocation] instance.
  PlaceLocation({
    required this.latitude,
    required this.longitude,
  });

  /// Creates a [PlaceLocation] instance from a map.
  factory PlaceLocation.fromMap(Map<String, dynamic> json) {
    return PlaceLocation(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  /// Converts the [PlaceLocation] instance into a map representation.
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
