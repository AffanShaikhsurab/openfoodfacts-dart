import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:openfoodfacts/interface/JsonObject.dart';
import 'package:openfoodfacts/model/OffTagged.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:openfoodfacts/utils/CountryHelper.dart';
import 'package:openfoodfacts/utils/TagType.dart';
import 'package:openfoodfacts/utils/TaxonomyQueryConfiguration.dart';

part 'TaxonomyPackagingMaterial.g.dart';

/// Fields of a [TaxonomyPackagingMaterial]
enum TaxonomyPackagingMaterialField implements OffTagged {
  ALL(offTag: 'all'),
  NAME(offTag: 'name'),
  SYNONYMS(offTag: 'synonyms'),
  CHILDREN(offTag: 'children'),
  PARENTS(offTag: 'parents');

  const TaxonomyPackagingMaterialField({required this.offTag});

  @override
  final String offTag;
}

/// A JSON-serializable version of a Packaging Material taxonomy result.
///
/// See [OpenFoodAPIClient.getTaxonomy] for more details on how to retrieve one
/// of these.
@CopyWith()
@JsonSerializable()
class TaxonomyPackagingMaterial extends JsonObject {
  TaxonomyPackagingMaterial({
    this.name,
    this.synonyms,
    this.children,
    this.parents,
  });

  factory TaxonomyPackagingMaterial.fromJson(Map<String, dynamic> json) =>
      _$TaxonomyPackagingMaterialFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TaxonomyPackagingMaterialToJson(this);

  /// Standard localized name.
  @JsonKey(fromJson: LanguageHelper.fromJsonStringMap, includeIfNull: false)
  Map<OpenFoodFactsLanguage, String>? name;

  /// Localized synonyms of the name.
  @JsonKey(fromJson: LanguageHelper.fromJsonStringMapList, includeIfNull: false)
  Map<OpenFoodFactsLanguage, List<String>>? synonyms;

  /// Children.
  @JsonKey(includeIfNull: false)
  List<String>? children;

  /// Parents.
  @JsonKey(includeIfNull: false)
  List<String>? parents;

  @override
  String toString() => toJson().toString();
}

/// Configuration for packaging materials API query.
class TaxonomyPackagingMaterialQueryConfiguration
    extends TaxonomyQueryConfiguration<TaxonomyPackagingMaterial,
        TaxonomyPackagingMaterialField> {
  /// Configuration to get the packaging materials that match the [tags].
  TaxonomyPackagingMaterialQueryConfiguration({
    required List<String> tags,
    List<OpenFoodFactsLanguage>? languages,
    OpenFoodFactsCountry? country,
    List<TaxonomyPackagingMaterialField> fields = const [],
    List<Parameter> additionalParameters = const [],
    bool includeChildren = false,
  }) : super(
          TagType.PACKAGING_MATERIALS,
          tags,
          languages: languages,
          country: country,
          includeChildren: includeChildren,
          fields: fields,
          additionalParameters: additionalParameters,
        );

  TaxonomyPackagingMaterialQueryConfiguration.roots({
    List<OpenFoodFactsLanguage>? languages,
    OpenFoodFactsCountry? country,
    List<TaxonomyPackagingMaterialField> fields = const [],
    List<Parameter> additionalParameters = const [],
    bool includeChildren = false,
  }) : super.roots(
          TagType.PACKAGING_MATERIALS,
          languages: languages,
          country: country,
          includeChildren: includeChildren,
          fields: fields,
          additionalParameters: additionalParameters,
        );

  @override
  Map<String, TaxonomyPackagingMaterial> convertResults(dynamic jsonData) {
    if (jsonData is! Map<String, dynamic>) {
      return const {};
    }
    return jsonData
        .map<String, TaxonomyPackagingMaterial>((String key, dynamic taxonomy) {
      if (taxonomy is! Map<String, dynamic>) {
        assert(false, 'Received JSON Packaging Material is not a Map');
        return MapEntry(key, TaxonomyPackagingMaterial.fromJson({}));
      }
      return MapEntry(key, TaxonomyPackagingMaterial.fromJson(taxonomy));
    });
  }

  @override
  Set<TaxonomyPackagingMaterialField> get ignoredFields =>
      const {TaxonomyPackagingMaterialField.ALL};

  @override
  Iterable<String> convertFieldsToStrings(
          Iterable<TaxonomyPackagingMaterialField> fields) =>
      fields
          .where((TaxonomyPackagingMaterialField field) =>
              !ignoredFields.contains(field))
          .map<String>((TaxonomyPackagingMaterialField field) => field.offTag);
}
