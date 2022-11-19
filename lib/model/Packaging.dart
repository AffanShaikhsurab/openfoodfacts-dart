import 'package:json_annotation/json_annotation.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

import '../interface/JsonObject.dart';

part 'Packaging.g.dart';

@CopyWith()
@JsonSerializable()
class Packaging extends JsonObject {
  @JsonKey(includeIfNull: false, fromJson: JsonObject.parseDouble)
  double? value;
  @JsonKey(includeIfNull: false, fromJson: JsonObject.parseDouble)
  double? score;

  Packaging({this.score, this.value});

  factory Packaging.fromJson(Map<String, dynamic> json) =>
      _$PackagingFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PackagingToJson(this);
}
