import 'main_text_matched_substring.dart';
import 'secondary_text_matched_substring.dart';

class StructuredFormatting {
  String? mainText;
  List<MainTextMatchedSubstring>? mainTextMatchedSubstrings;
  String? secondaryText;
  List<SecondaryTextMatchedSubstring>? secondaryTextMatchedSubstrings;

  StructuredFormatting({
    this.mainText,
    this.mainTextMatchedSubstrings,
    this.secondaryText,
    this.secondaryTextMatchedSubstrings,
  });

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'] as String?,
      mainTextMatchedSubstrings:
          (json['main_text_matched_substrings'] as List<dynamic>?)
              ?.map((e) =>
                  MainTextMatchedSubstring.fromJson(e as Map<String, dynamic>))
              .toList(),
      secondaryText: json['secondary_text'] as String?,
      secondaryTextMatchedSubstrings: (json['secondary_text_matched_substrings']
              as List<dynamic>?)
          ?.map((e) =>
              SecondaryTextMatchedSubstring.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'main_text': mainText,
        'main_text_matched_substrings':
            mainTextMatchedSubstrings?.map((e) => e.toJson()).toList(),
        'secondary_text': secondaryText,
        'secondary_text_matched_substrings':
            secondaryTextMatchedSubstrings?.map((e) => e.toJson()).toList(),
      };
}
