import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:kay_khau_frontend/controller/LoginCon.dart';
import 'package:kay_khau_frontend/view/HomeScreen.dart';
import 'package:kay_khau_frontend/controller/AddFood.dart';
import 'package:kay_khau_frontend/controller/getFood.dart';
import 'package:provider/provider.dart';
import '../Models/food.dart';

class AddPrefredList extends StatefulWidget {
  const AddPrefredList({super.key});

  @override
  State<AddPrefredList> createState() => _AddPrefredListState();
}

class _AddPrefredListState extends State<AddPrefredList> {
  final Set<Food> selectedBreakfast = {}; // Track selected breakfast items
  final Set<Food> selectedLunch = {}; // Track selected lunch items
  final Set<Food> selectedDinner = {}; // Track selected dinner items

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<GetFood>(context, listen: false).getFood();
    });
  }

  // Helper method to handle item selection
  void handleSelection(Food food, Set<Food> selectedItems) {
    setState(() {
      if (selectedItems.contains(food)) {
        selectedItems.remove(food); // Deselect the item
      } else {
        if (selectedItems.length < 5) {
          selectedItems
              .add(food); // Select the item only if less than 5 are selected
        }
      }
    });
  }

  // Method to submit the preference list
  Future<void> submitPreferenceList() async {
    if (selectedBreakfast.length > 4) {
      // Perform the submission operation
      await Provider.of<AddFood>(context, listen: false).addPreferenceList(
        Provider.of<LoginCon>(context, listen: false).loggedInUser!.id,
        selectedBreakfast,
        selectedLunch,
        selectedDinner,
      );

      // Check if the operation was successful
      if (Provider.of<AddFood>(context, listen: false).success) {
        if (mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const Homescreen();
          }));
        }
      } else {
        // Show a dialog if the submission failed
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(Provider.of<AddFood>(context).message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Show a dialog if not enough items were selected
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Select 5 Items From Each"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var getProvider = Provider.of<GetFood>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Add Favourite Breakfast",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        Flexible(
          child: getProvider.isloading
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  padding: const EdgeInsets.all(15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: getProvider.foodListBreakFast.length,
                  itemBuilder: (context, index) {
                    Food foodItem = getProvider.foodListBreakFast[index];
                    bool isSelected = selectedBreakfast.contains(foodItem);
                    return GestureDetector(
                      onTap: () {
                        handleSelection(
                            foodItem, selectedBreakfast); // Handle selection
                      },
                      onDoubleTap: () {
                        showFoodDialog(foodItem); // Show dialog on double tap
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isSelected
                              ? Colors.green
                              : Colors.purple, // Change color on selection
                        ),
                        child: Text(
                          foodItem.name,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
        ),
        const Text(
          "Add Favourite Lunch",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        Flexible(
          child: getProvider.isloading
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  padding: const EdgeInsets.all(15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: getProvider.foodList.length,
                  itemBuilder: (context, index) {
                    Food foodItem = getProvider.foodList[index];
                    bool isSelected = selectedLunch.contains(foodItem);
                    return GestureDetector(
                      onTap: () {
                        handleSelection(
                            foodItem, selectedLunch); // Handle selection
                      },
                      onDoubleTap: () {
                        showFoodDialog(foodItem); // Show dialog on double tap
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isSelected
                              ? Colors.green
                              : Colors.purple, // Change color on selection
                        ),
                        child: Text(
                          foodItem.name,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
        ),
        const Text(
          "Add Favourite Dinner",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        Flexible(
          child: getProvider.isloading
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  padding: const EdgeInsets.all(15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: getProvider.foodList.length,
                  itemBuilder: (context, index) {
                    Food foodItem = getProvider.foodList[index];
                    bool isSelected = selectedDinner.contains(foodItem);
                    return GestureDetector(
                      onTap: () {
                        handleSelection(
                            foodItem, selectedDinner); // Handle selection
                      },
                      onDoubleTap: () {
                        showFoodDialog(foodItem); // Show dialog on double tap
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isSelected
                              ? Colors.green
                              : Colors.purple, // Change color on selection
                        ),
                        child: Text(
                          foodItem.name,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
        ),
        GestureDetector(
          onTap: () {
            log('Submit button tapped');
            submitPreferenceList(); // Call the function to submit preferences
          },
          child: Container(
            margin: const EdgeInsets.all(20),
            height: 50,
            width: 150,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.amber, borderRadius: BorderRadius.circular(10)),
            child: const Text(
              "Submit",
              style: TextStyle(
                  fontSize: 15, decorationStyle: null, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  // Method to show food details in a dialog
  void showFoodDialog(Food foodItem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(foodItem.name),
          content: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                foodItem.image,
                height: 150,
                width: 150,
              )),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
