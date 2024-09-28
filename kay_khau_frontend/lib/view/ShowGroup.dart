import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:kay_khau_frontend/Models/group.dart';
import 'package:kay_khau_frontend/controller/LoginCon.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';

class Showgroup extends StatefulWidget {
  final String groupid;
  const Showgroup({super.key, required this.groupid});

  @override
  State<Showgroup> createState() => _ShowgroupState();
}

class _ShowgroupState extends State<Showgroup> {
  IO.Socket? socket;
  Map<String, dynamic>? groupData;
  Group? gr;
  String formattedDate =
      DateTime.now().toIso8601String().split('T')[0]; // For vote date

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  void connectToServer() {
    socket = IO.io('http://localhost:3000/group', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();

    socket!.on('connect', (_) {
      log('Connected to the server');
      socket!.emit('getGroupData', widget.groupid);
    });

    socket!.on('groupData', (data) {
      log('Received group data: $data');
      setState(() {
        groupData = data['group'];
        gr = Group.fromJson(data['group']);
      });
    });

    socket!.on('disconnect', (_) {
      log('Disconnected from the server');
    });
  }

  void sendVote() {
    socket!.emit("vote", {
      "groupId": widget.groupid,
      "date": formattedDate,
      "meal": 'breakfast',
      "foodItemId": '66ec2a7cbf3447e7acfdbf9f',
      "userId": Provider.of<LoginCon>(context).loggedInUser!.id
    });

    socket!.on('voteResult', (response) {
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Vote submitted successfully"),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Vote submission failed"),
        ));
      }
    });
  }

  @override
  void dispose() {
    socket?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    // Format the current date as "September 27, 2024"
    String formattedDate = DateFormat('MMMM d, yyyy').format(now);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: sendVote,
        child: const Icon(Icons.how_to_vote),
      ),
      appBar: AppBar(
        title: Text(groupData != null ? gr!.name : 'Loading Group...'),
      ),
      body: groupData != null
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //top Selected date
                    Text(formattedDate),
                    const SizedBox(height: 20),
                    const Text(
                      'Choices of the day',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    _buildCurrentDayChoicesSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildMealColumn(String mealType, String mealInfo) {
    return Column(
      children: [
        Text(
          mealType,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          mealInfo,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildCurrentDayChoicesSection() {
    List<dynamic> dailyChoices = groupData!['dailyChoices'];
    // Filter for current day's choices
    final currentDayChoice = dailyChoices.firstWhere(
      (choice) => choice['date'].toString().startsWith(formattedDate),
      orElse: () => null,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        if (currentDayChoice != null) ...[
          _buildMealSection('Breakfast', currentDayChoice['breakfast']),
          _buildMealSection('Lunch', currentDayChoice['lunch']),
          _buildMealSection('Dinner', currentDayChoice['dinner']),
        ] else
          const Text('No choices available for today'),
      ],
    );
  }

  Widget _buildMealSection(String mealType, List<dynamic> meals) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$mealType: ',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          meals.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: meals.map((meal) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Text(meal['foodItem']['name']),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child: Image.network(
                            meal['foodItem']['image'],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.favorite,
                              size: 15,
                              color: Colors.red,
                            ),
                            Text(
                              '${meal['voteNumber']}',
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    );
                  }).toList(),
                )
              : Column(
                  children: [
                    Text('No votes for $mealType yet'),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(75),
                      child: Image.network(
                        "https://w7.pngwing.com/pngs/116/858/png-transparent-computer-icons-meal-food-meal-icon-food-logo-eating-thumbnail.png",
                        height: 100,
                        width: 100,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.no_meals),
                          );
                        },
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
