// lib/models/product_model.dart

class Product {
  final int id;
  final String title;
  final String slug;
  final double price;
  final String description;
  final Category category;  // Use the shared Category class
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      price: json['price'].toDouble(),
      description: json['description'],
      category: Category.fromJson(json['category']),  // Use Category.fromJson
      images: List<String>.from(json['images']),
    );
  }
}


// lib/models/category.dart

class Category {
  final int id;
  final String name;
  final String slug;
  final String image;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      image: json['image'],
    );
  }
}

