/// Represents a single prediction for an autocomplete query in Google Places API.
class Prediction {
  /// The unique identifier of the place.
  final String? placeId;

  /// The title or main text of the place prediction.
  final String? title;

  /// The description or secondary text of the place prediction.
  final String? description;

  /// Constructs a [Prediction] object.
  ///
  /// All parameters are optional.
  Prediction({
    this.placeId,
    this.title,
    this.description,
  });

  /// Creates a copy of the current [Prediction] instance with optional updated values.
  ///
  /// If a value is not provided, the existing value is retained.
  Prediction copyWith({
    String? placeId,
    String? title,
    String? description,
  }) {
    return Prediction(
      placeId: placeId ?? this.placeId,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  /// Converts the [Prediction] instance to a map for serialization.
  ///
  /// Returns a map representation of the object, where the keys are the field names.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'placeId': placeId,
      'title': title,
      'description': description,
    };
  }

  /// Factory method to create a [Prediction] instance from a map.
  ///
  /// The map should contain keys matching the expected structure, such as
  /// `placeId`, `structuredFormat.mainText.text`, and `structuredFormat.secondaryText.text`.
  factory Prediction.fromMap(Map<String, dynamic> map) {
    return Prediction(
      placeId: map['placeId'],
      title: map['structuredFormat']?['mainText']?['text'],
      description: map['structuredFormat']?['secondaryText']?['text'],
    );
  }
}
