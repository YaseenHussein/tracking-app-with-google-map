class SecondaryTextMatchedSubstring {
  int? length;
  int? offset;

  SecondaryTextMatchedSubstring({this.length, this.offset});

  factory SecondaryTextMatchedSubstring.fromJson(Map<String, dynamic> json) {
    return SecondaryTextMatchedSubstring(
      length: json['length'] as int?,
      offset: json['offset'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'length': length,
        'offset': offset,
      };
}
