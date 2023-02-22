
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../db_constants.dart';
part 'product.g.dart';

@JsonSerializable()
@HiveType(typeId: db_product)
class Product extends Equatable with HiveObjectMixin {

  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? title;
  @HiveField(2)
  final String? description;
  @HiveField(3)
  final int? price;
  @HiveField(4)
  final double? discountPercentage;
  @HiveField(5)
  final double? rating;
  @HiveField(6)
  final int? stock;
  @HiveField(7)
  final String? brand;
  @HiveField(8)
  final String? category;
  @HiveField(9)
  final String? thumbnail;
  @HiveField(10)
  final List<String>? images;

  Product(this.id, this.title, this.description, this.price, this.discountPercentage, this.rating, this.stock, this.brand, this.category, this.thumbnail, this.images);

  @override
  List<Object?> get props => [id];

  factory Product.fromJson(Map<String, dynamic> productJson) => _$ProductFromJson(productJson);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

}