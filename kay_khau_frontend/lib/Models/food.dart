class Food {
  String id;
  String name;
  String type;
  String image;

  Food({
    required this.image,
    required this.name,
    required this.type,
    required this.id
  });

  // Factory method to create a Food object from JSON
  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'type': type,
      'image': image,
    };
  }
}
