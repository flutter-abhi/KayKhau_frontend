import 'food.dart';
class Group {
  String id;
  String name;
  String inviteCode;
  List<String> members;
  List<Food> groupFoods;
  List<DailyChoice> dailyChoices;

  Group({
    required this.id,
    required this.name,
    required this.inviteCode,
    required this.members,
    required this.groupFoods,
    required this.dailyChoices,
  });

  // Factory method to create a Group from JSON
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json["_id"],
      name: json["name"],
      inviteCode: json["inviteCode"],
      members: List<String>.from(json["members"]),
      groupFoods: List<Food>.from(json["groupFoods"].map((food) => Food.fromJson(food))),
      dailyChoices: List<DailyChoice>.from(json["dailyChoices"].map((choice) => DailyChoice.fromJson(choice))),
    );
  }

  // Method to convert Group instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'inviteCode': inviteCode,
      'members': members,
      'groupFoods': groupFoods.map((food) => food.toJson()).toList(),
      'dailyChoices': dailyChoices.map((choice) => choice.toJson()).toList(),
    };
  }
}


class DailyChoice {
  String date;
  List<Meal> breakfast;
  List<Meal> lunch;
  List<Meal> dinner;

  DailyChoice({
    required this.date,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });

  // Factory method to create a DailyChoice from JSON
  factory DailyChoice.fromJson(Map<String, dynamic> json) {
    return DailyChoice(
      date: json["date"],
      breakfast: List<Meal>.from(json["breakfast"].map((meal) => Meal.fromJson(meal))),
      lunch: List<Meal>.from(json["lunch"].map((meal) => Meal.fromJson(meal))),
      dinner: List<Meal>.from(json["dinner"].map((meal) => Meal.fromJson(meal))),
    );
  }

  // Method to convert DailyChoice instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'breakfast': breakfast.map((meal) => meal.toJson()).toList(),
      'lunch': lunch.map((meal) => meal.toJson()).toList(),
      'dinner': dinner.map((meal) => meal.toJson()).toList(),
    };
  }
}

class Meal {
  Food foodItem;
  List<String> votes;
  int voteNumber;

  Meal({
    required this.foodItem,
    required this.votes,
    required this.voteNumber,
  });

  // Factory method to create a Meal from JSON
  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      foodItem: Food.fromJson(json['foodItem']),
      votes: List<String>.from(json['votes']),
      voteNumber: json['voteNumber'],
    );
  }

  // Method to convert Meal instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'foodItem': foodItem.toJson(),
      'votes': votes,
      'voteNumber': voteNumber,
    };
  }
}
