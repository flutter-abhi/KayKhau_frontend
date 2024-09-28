import 'group.dart';

class User {
  String id;
  String email;
  String password;
  PreferredFoods preferredFoods;
  List<Group> groups;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.preferredFoods,
    required this.groups,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"],
      email: json['email'],
      password: json['password'],
      preferredFoods: PreferredFoods.fromJson(json['preferredFoods']),
      groups: List<Group>.from(
          json['groups'].map((group) => Group.fromJson(group))),
    );
  }

  // Method to convert User instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'password': password,
      'preferredFoods': preferredFoods.toJson(),
      'groups': groups.map((group) => group.toJson()).toList(),
    };
  }
}

class PreferredFoods {
  List<String> breakfast;
  List<String> lunch;
  List<String> dinner;

  PreferredFoods({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });

  // Factory method to create PreferredFoods from JSON
  factory PreferredFoods.fromJson(Map<String, dynamic> json) {
    return PreferredFoods(
      breakfast: List<String>.from(json['breakfast']),
      lunch: List<String>.from(json['lunch']),
      dinner: List<String>.from(json['dinner']),
    );
  }

  // Method to convert PreferredFoods instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'breakfast': breakfast,
      'lunch': lunch,
      'dinner': dinner,
    };
  }
}
