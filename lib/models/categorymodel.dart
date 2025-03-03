class Category {
  final int id;
  final String category_name;

  Category({required this.id, required this.category_name});

  // Factory constructor to convert JSON into a Dart object
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], category_name: json['category_name']);
  }
}
