import 'package:app/setup_process/setup_style.dart';
import 'package:flutter/material.dart';
import '../data_model/user_db.dart';

import 'setup_top_bar.dart';
import 'individual_setup_swipe.dart';

class SetupProfilePage extends StatefulWidget {
  final User newUser;

  const SetupProfilePage({Key? key, required this.newUser}) : super(key: key);

  @override
  SetupProfilePageState createState() => SetupProfilePageState();
}

class SetupProfilePageState extends State<SetupProfilePage> {
  late TextEditingController displayNameController;
  late TextEditingController usernameController;
  late User user;
  TextEditingController biographyController = TextEditingController();

  SetupProfilePageState();

  @override
  void initState() {
    super.initState();
    displayNameController =
        TextEditingController(text: widget.newUser.displayName);
    usernameController = TextEditingController(text: widget.newUser.username);
    user = widget.newUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SetupTopBar(
                state:
                    widget.newUser.isBusiness ? 'profileBusiness' : 'profile'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20), // Add spacing
                      ProfilePictureUploadButton(onPressed: () {}),
                      const SizedBox(height: 20),
                      _buildTextField("Display Name", displayNameController),
                      _buildTextField("Username", usernameController),
                      _buildTextField('Biography', biographyController,
                          width: 500, height: 120, lines: 3),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // ElevatedButton(
                          //   onPressed: () {
                          //     Navigator.pop(context);
                          //   },
                          //   style: ElevatedButton.styleFrom(
                          //     padding: const EdgeInsets.symmetric(vertical: 0),
                          //   ),
                          //   child: const Text('Back'),
                          // ),
                          ElevatedButton(
                            onPressed: () {
                              final updatedDisplayName =
                                  displayNameController.text;
                              final updatedBiography = biographyController.text;
                              final updatedUsername = usernameController.text;
                              try {
                                userDB.updateUserProfileFields(
                                  user,
                                  displayName: updatedDisplayName,
                                  newUsername: updatedUsername,
                                  biography: updatedBiography,
                                );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            widget.newUser.isBusiness
                                                ? SetupStyle(
                                                    newUser: widget.newUser)
                                                : IndividualSetupSwipe(
                                                    newUser: widget.newUser)));
                              } catch (e) {
                                final exceptionMessage =
                                    e.toString().replaceAll("Exception:", "");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(exceptionMessage),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 0),
                            ),
                            child: const Text('Next'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isObscure = false,
      double width = 500,
      double height = 60,
      int lines = 1}) {
    return Container(
      width: width, // Set the width
      height: height, // Set the height
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        maxLines: lines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}

class ProfilePictureUploadButton extends StatelessWidget {
  final Function() onPressed;

  const ProfilePictureUploadButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_a_photo_outlined,
                size: 40,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 8), // Add spacing between Icon and Text
              Text(
                'Add Photo',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
