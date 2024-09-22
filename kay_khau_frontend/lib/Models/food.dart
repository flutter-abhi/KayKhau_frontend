class Food {
  String name;
  String type;
  String image;

  Food({required this.image, required this.name, required this.type});

  // Factory method to create a Food object from JSON
  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      name: json['name'],
      type: json['type'],
      image: json['image'],
    );
  }
}
