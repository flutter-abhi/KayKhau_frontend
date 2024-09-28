import 'dart:convert'; // for json encode/decode
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kay_khau_frontend/view/ShowGroup.dart';
import 'package:provider/provider.dart';
import 'package:kay_khau_frontend/controller/LoginCon.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final TextEditingController _inviteCodeController = TextEditingController();
  bool isLoading = false;

  // API call to join group
  // Show alert dialog for invite code input

  @override
  Widget build(BuildContext context) {
    final userCon = Provider.of<LoginCon>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        actions: (userCon.loggedInUser!.groups.isNotEmpty)
            ? [
                IconButton(
                  onPressed: () {
                    showJoinGroupDialog(false);
                  },
                  icon: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.amber.shade300),
                    height: 50,
                    width: 150,
                    child: const Text("Join Group"),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showJoinGroupDialog(true);
                    },
                    icon: const Icon(Icons.add))
              ]
            : [],
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: (userCon.loggedInUser!.groups.isEmpty)
          ? Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white, // Background color
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // Position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Welcome, ${Provider.of<LoginCon>(context).loggedInUser!.email}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 148, 247, 155),
                        ),
                        onPressed: () {
                          showJoinGroupDialog(
                              false); // Show the dialog on pressing 'Join Group'
                        },
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                "Join Group",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 255, 160, 131),
                        ),
                        onPressed: () {
                          showJoinGroupDialog(true);
                        },
                        child: const Text(
                          "Create Group",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: userCon.loggedInUser!.groups.length,
                itemBuilder: (context, index) {
                  var group = userCon.loggedInUser!.groups[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Showgroup(
                              groupid: userCon.loggedInUser!.groups[index].id);
                        }));
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurpleAccent,
                          child: Text(
                            group.name[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          group.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text("Invite Code: ${group.inviteCode}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          onPressed: () {
                            // Handle navigation to group details
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0), // Adds padding for floating effect
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20), // Rounded corners
          child: BottomNavigationBar(
            backgroundColor: Colors.white
                .withOpacity(0.9), // Slight transparency for floating effect
            elevation: 10, // Shadow for floating effect
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue, // Color for selected item
            unselectedItemColor: Colors.grey, // Color for unselected items
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void showJoinGroupDialog(bool isCreating) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Join Group'),
          content: TextField(
            controller: _inviteCodeController,
            decoration: InputDecoration(
                hintText:
                    (isCreating) ? 'Enter Group Name' : 'Enter Invite Code'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_inviteCodeController.text.isNotEmpty) {
                  Navigator.of(context).pop(); // Close the dialog
                  (isCreating)
                      ? await createGroup(_inviteCodeController.text)
                      : await joinGroup(
                          _inviteCodeController.text); // Make API call
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter an invite code.')),
                  );
                }
              },
              child: Text((isCreating) ? 'Create' : 'Join'),
            ),
          ],
        );
      },
    );
  }

  //for jionig the group
  //
  Future<void> joinGroup(String inviteCode) async {
    setState(() {
      isLoading = true;
    });

    final userId =
        Provider.of<LoginCon>(context, listen: false).loggedInUser!.id;

    // Prepare the request body
    var requestBody = {
      "inviteCode": inviteCode,
      "userId": userId,
    };
    log(userId);
    try {
      // Make the HTTP POST request to join group
      var response = await http.post(
        Uri.parse("http://localhost:3000/join-group"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      log("${response.statusCode}");
      // Handle the response
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        log("${responseData}");

        setState(() {
          var user = Provider.of<LoginCon>(context, listen: false).loggedInUser;
          Provider.of<LoginCon>(context, listen: false)
              .loginUser(user!.email, user.password);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully joined the group!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to join the group. Please try again.')),
        );
      }
    } catch (error) {
      log("$error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred. Please try again later.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  //creating group
  Future<void> createGroup(String groupName) async {
    setState(() {
      isLoading = true;
    });

    final userId =
        Provider.of<LoginCon>(context, listen: false).loggedInUser!.id;

    var requestBody = {
      "name": groupName,
      "userId": userId,
    };

    try {
      var response = await http.post(
        Uri.parse("http://localhost:3000/create-group"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = jsonDecode(response.body);

        // Fetch and update the user's group information
        var user = Provider.of<LoginCon>(context, listen: false).loggedInUser;
        await Provider.of<LoginCon>(context, listen: false)
            .loginUser(user!.email, user.password);

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Group created successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to create group. Please try again.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred. Please try again later.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
