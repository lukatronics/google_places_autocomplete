/// Represents the detailed information about a place fetched from the Google Places API.

class PlaceDetails {
  /// The name of the place (human‑readable if requested, otherwise resource name).
  final String? name;

  /// Fully formatted address (Google formattedAddress).
  final String? formattedAddress;

  /// Postal address object rendered into a single string (postalAddress).
  final String? postalAddress;

  /// Street (route) component, e.g. “Main St”.
  final String? streetAddress;

  /// Street number (house number), e.g. “123”.
  final String? streetNumber;

  /// Locality / city.
  final String? city;

  /// First‑level administrative area (state, province).
  final String? state;

  /// Second‑level administrative area / region.
  final String? region;

  /// Postal or ZIP code.
  final String? zipCode;

  /// Country name.
  final String? country;

  /// Latitude in decimal degrees.
  final double? lat;

  /// Longitude in decimal degrees.
  final double? lon;

  /// Google Maps URI (deep link).
  final String? googleMapsUri;

  /// All place types Google returns.
  final List<String>? types;

  /// Primary type display name (human‑readable).
  final String? primaryTypeDisplayName;

  /// Primary type ID.
  final String? primaryType;

  /// Photo metadata list (may contain base64 payloads).
  final List<PhotoMetadata>? photos;

  /// Constructor for creating a [PlaceDetails] instance.
  PlaceDetails({
    this.name,
    this.formattedAddress,
    this.postalAddress,
    this.streetAddress,
    this.streetNumber,
    this.city,
    this.state,
    this.region,
    this.zipCode,
    this.country,
    this.lat,
    this.lon,
    this.googleMapsUri,
    this.types,
    this.primaryTypeDisplayName,
    this.primaryType,
    this.photos,
  });

  /// Creates a copy of the [PlaceDetails] instance with updated values.
  ///
  /// If a value is not provided, the existing value is retained.
  PlaceDetails copyWith({
    String? name,
    String? formattedAddress,
    String? postalAddress,
    String? streetAddress,
    String? streetNumber,
    String? city,
    String? state,
    String? region,
    String? zipCode,
    String? country,
    double? lat,
    double? lon,
    String? googleMapsUri,
    List<String>? types,
    String? primaryTypeDisplayName,
    String? primaryType,
    List<PhotoMetadata>? photos,
  }) {
    return PlaceDetails(
      name: name ?? this.name,
      formattedAddress: formattedAddress ?? this.formattedAddress,
      postalAddress: postalAddress ?? this.postalAddress,
      streetAddress: streetAddress ?? this.streetAddress,
      streetNumber: streetNumber ?? this.streetNumber,
      city: city ?? this.city,
      state: state ?? this.state,
      region: region ?? this.region,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      googleMapsUri: googleMapsUri ?? this.googleMapsUri,
      types: types ?? this.types,
      primaryTypeDisplayName:
          primaryTypeDisplayName ?? this.primaryTypeDisplayName,
      primaryType: primaryType ?? this.primaryType,
      photos: photos ?? this.photos,
    );
  }

  /// Converts the [PlaceDetails] instance into a map representation.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'formattedAddress': formattedAddress,
      'postalAddress': postalAddress,
      'streetAddress': streetAddress,
      'streetNumber': streetNumber,
      'city': city,
      'state': state,
      'region': region,
      'zipCode': zipCode,
      'country': country,
      'lat': lat,
      'lon': lon,
      'googleMapsUri': googleMapsUri,
      'types': types,
      'primaryTypeDisplayName': primaryTypeDisplayName,
      'primaryType': primaryType,
      'photos': photos?.map((e) => e.toMap()).toList(),
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
      name: map['displayName']?['text'] ?? map['name'],
      formattedAddress: map['formattedAddress'],
      postalAddress: map['postalAddress'],
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
      lat: (map['location']?['latitude']) ?? map['location']?['lat'],
      lon: (map['location']?['longitude']) ?? map['location']?['lng'],
      googleMapsUri: map['googleMapsUri'],
      types: (map['types'] as List?)?.cast<String>(),
      primaryTypeDisplayName: map['primaryTypeDisplayName'],
      primaryType: map['primaryType'],
      photos: (map['photos'] as List?)
          ?.map((e) => PhotoMetadata.fromMap(e))
          .toList(),
    );
  }
}

/// Photo metadata + optional base64 image payload
class PhotoMetadata {
  final String name; // places/…/photos/AX0…
  final int widthPx;
  final int heightPx;
  final List<String>? attributions;
  final String? base64; // media bytes (optional)

  PhotoMetadata({
    required this.name,
    required this.widthPx,
    required this.heightPx,
    this.attributions,
    this.base64,
  });

  factory PhotoMetadata.fromMap(Map<String, dynamic> m) => PhotoMetadata(
    name: m['name'],
    widthPx: m['widthPx'] ?? 0,
    heightPx: m['heightPx'] ?? 0,
    attributions: (m['attributions'] as List?)
        ?.map((e) => e.toString())
        .toList(),
    base64: m['base64'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'widthPx': widthPx,
    'heightPx': heightPx,
    if (attributions != null) 'attributions': attributions,
    if (base64 != null) 'base64': base64,
  };
}
