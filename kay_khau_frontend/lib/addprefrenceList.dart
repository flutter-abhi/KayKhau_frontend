import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kay_khau_frontend/controller/getFood.dart';
import 'package:provider/provider.dart';

class AddPrefredList extends StatefulWidget {
  const AddPrefredList({super.key});

  @override
  State<AddPrefredList> createState() => _AddPrefredListState();
}

class _AddPrefredListState extends State<AddPrefredList> {
  @override
  void initState() {
    Future.microtask(() {
      Provider.of<GetFood>(context, listen: false).getFood();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var getProvider = Provider.of<GetFood>(context);
    return Column(
      children: [
        const Text(
          "Add Favourite Breakfast",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        SizedBox(
          height: 700, // Set appropriate height for the grid
          child: getProvider.isloading
              ? const Center(
                  child:
                      CircularProgressIndicator()) // Show a loader while data is loading
              : GridView.builder(
                  padding: const EdgeInsets.all(15),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // 3 items per row
                    childAspectRatio: 5, // Adjust this to control item height
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: getProvider.foodList.length,
                  itemBuilder: (context, index) {
                    log("${getProvider.foodList.length}");
                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.purple,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            getProvider.foodList[index].name,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
