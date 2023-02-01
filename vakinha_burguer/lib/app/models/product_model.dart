import 'dart:convert';

class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;

  ProductModel(
    this.id,
    this.name,
    this.description,
    this.price,
    this.image,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      map['id']?.toInt() ?? 0,
      map['name'] ?? '',
      map['description'] ?? '',
      map['price']?.toDouble() ?? 0.0,
      map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));
}
