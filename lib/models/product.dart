import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final int? id;
  final String? title;
  final String? description;
  final double? price;
  final String? thumbnail;

  Product({
    this.id,
    this.title,
    this.description,
    this.price,
    this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
