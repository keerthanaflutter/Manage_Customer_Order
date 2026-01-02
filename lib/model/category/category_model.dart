import 'package:flutter/material.dart';

class CategoryItem {
  final String title;
  final IconData icon;
  final Color color;

  CategoryItem({
    required this.title,
    required this.icon,
    required this.color,
  });

  // Convert CategoryItem to Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'icon': icon.codePoint,  // Saving icon as its codePoint (you can change this if needed)
      'color': color.value,    // Saving the color as integer value
    };
  }

  // Convert Map to CategoryItem
  factory CategoryItem.fromMap(Map<String, dynamic> map) {
    return CategoryItem(
      title: map['title'],
      icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
      color: Color(map['color']),
    );
  }
}

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final List<String> images;
  final CategoryItem category;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
  });

  // Convert a Product object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'images': images,
      'category': category.toMap(),  // Convert the CategoryItem to a Map as well
    };
  }

  // Convert a Map to a Product object
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      price: map['price'],
      images: List<String>.from(map['images']),
      category: CategoryItem.fromMap(map['category']),
    );
  }
}
