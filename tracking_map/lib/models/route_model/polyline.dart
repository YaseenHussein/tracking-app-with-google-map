class PolylineModel {
  String? encodedPolyline;

  PolylineModel({this.encodedPolyline});

  factory PolylineModel.fromJson(Map<String, dynamic> json) => PolylineModel(
        encodedPolyline: json['encodedPolyline'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'encodedPolyline': encodedPolyline,
      };
}
