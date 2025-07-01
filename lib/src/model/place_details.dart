// filepath: /Users/mrcse/Cuboid Work/google_places_autocomplete/lib/src/model/place_details.dart

/// Represents the detailed information about a place fetched from the Google Places API.
class PlaceDetails {
  /// The name of the place.
  final String? name;

  /// The national format phone number of the place.
  final String? nationalPhoneNumber;

  /// The international format phone number of the place.
  final String? internationalPhoneNumber;

  /// The formatted phone number of the place.
  final String? formattedPhoneNumber;

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

  /// The location coordinates of the place.
  final Location? location;

  /// The Google Maps URL for the place.
  final String? googleMapsUri;

  /// The website URL associated with the place.
  final String? websiteUri;

  /// The website URL of the place (alias for websiteUri).
  final String? website;

  /// The rating of the place (0.0 to 5.0).
  final double? rating;

  /// The total number of user ratings for the place.
  final int? userRatingsTotal;

  /// The geometry information of the place (contains location).
  final Geometry? geometry;

  /// Constructor for creating a [PlaceDetails] instance.
  PlaceDetails({
    this.name,
    this.nationalPhoneNumber,
    this.internationalPhoneNumber,
    this.formattedPhoneNumber,
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
    this.website,
    this.rating,
    this.userRatingsTotal,
    this.geometry,
  });

  /// Creates a copy of the [PlaceDetails] instance with updated values.
  ///
  /// If a value is not provided, the existing value is retained.
  PlaceDetails copyWith({
    String? name,
    String? nationalPhoneNumber,
    String? internationalPhoneNumber,
    String? formattedPhoneNumber,
    String? formattedAddress,
    String? streetAddress,
    String? streetNumber,
    String? city,
    String? state,
    String? region,
    String? zipCode,
    String? country,
    Location? location,
    String? googleMapsUri,
    String? websiteUri,
    String? website,
    double? rating,
    int? userRatingsTotal,
    Geometry? geometry,
  }) {
    return PlaceDetails(
      name: name ?? this.name,
      nationalPhoneNumber: nationalPhoneNumber ?? this.nationalPhoneNumber,
      internationalPhoneNumber:
          internationalPhoneNumber ?? this.internationalPhoneNumber,
      formattedPhoneNumber: formattedPhoneNumber ?? this.formattedPhoneNumber,
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
      website: website ?? this.website,
      rating: rating ?? this.rating,
      userRatingsTotal: userRatingsTotal ?? this.userRatingsTotal,
      geometry: geometry ?? this.geometry,
    );
  }

  /// Converts the [PlaceDetails] instance into a map representation.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nationalPhoneNumber': nationalPhoneNumber,
      'internationalPhoneNumber': internationalPhoneNumber,
      'formattedPhoneNumber': formattedPhoneNumber,
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
      'website': website,
      'rating': rating,
      'userRatingsTotal': userRatingsTotal,
      'geometry': geometry?.toJson(),
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
      name: map['displayName']['text'],
      nationalPhoneNumber: map['nationalPhoneNumber'],
      internationalPhoneNumber: map['internationalPhoneNumber'],
      formattedPhoneNumber: map['formattedPhoneNumber'],
      formattedAddress: map['formattedAddress'],
      streetAddress: extractAddressComponent(map['addressComponents'], 'route'),
      streetNumber: extractAddressComponent(
        map['addressComponents'],
        'street_number',
      ),
      city: extractAddressComponent(map['addressComponents'], 'locality'),
      state: extractAddressComponent(
        map['addressComponents'],
        'administrative_area_level_1',
      ),
      region: extractAddressComponent(
        map['addressComponents'],
        'administrative_area_level_2',
      ),
      zipCode: extractAddressComponent(map['addressComponents'], 'postal_code'),
      country: extractAddressComponent(map['addressComponents'], 'country'),
      location: map['location'] != null
          ? Location.fromMap(map['location'] as Map<String, dynamic>)
          : null,
      googleMapsUri: map['googleMapsUri'] != null
          ? map['googleMapsUri'] as String
          : null,
      websiteUri: map['websiteUri'] != null
          ? map['websiteUri'] as String
          : null,
      website: map['website'] as String?,
      rating: map['rating'] != null ? (map['rating'] as num).toDouble() : null,
      userRatingsTotal: map['userRatingsTotal'] as int?,
      geometry: map['location'] != null
          ? Geometry.fromJson(map['location'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Represents the geographical location of a place.
class Location {
  /// The latitude of the location.
  final double lat;

  /// The longitude of the location.
  final double lng;

  /// Constructor for creating a [Location] instance.
  Location({required this.lat, required this.lng});

  /// Creates a [Location] instance from a map.
  factory Location.fromMap(Map<String, dynamic> json) {
    return Location(
      lat: json['latitude'] ?? json['lat'] ?? 0.0,
      lng: json['longitude'] ?? json['lng'] ?? 0.0,
    );
  }

  /// Converts the [Location] instance into a map representation.
  Map<String, dynamic> toMap() {
    return {'lat': lat, 'lng': lng};
  }
}

/// Geometry information containing location coordinates
class Geometry {
  /// The location coordinates
  final Location? location;

  /// Constructor for creating a Geometry instance
  Geometry({this.location});

  /// Creates a Geometry from JSON map
  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      location: json['location'] != null
          ? Location.fromMap(json['location'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Converts the Geometry to a map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toMap();
    }
    return data;
  }
}
