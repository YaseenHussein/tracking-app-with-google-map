class RouteModifiersInfo {
  bool? avoidTolls;
  bool? avoidHighways;
  bool? avoidFerries;

  RouteModifiersInfo(
      {this.avoidTolls = false,
      this.avoidHighways = false,
      this.avoidFerries = false});

  factory RouteModifiersInfo.fromJson(Map<String, dynamic> json) {
    return RouteModifiersInfo(
      avoidTolls: json['avoidTolls'] as bool?,
      avoidHighways: json['avoidHighways'] as bool?,
      avoidFerries: json['avoidFerries'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'avoidTolls': avoidTolls,
        'avoidHighways': avoidHighways,
        'avoidFerries': avoidFerries,
      };
}
