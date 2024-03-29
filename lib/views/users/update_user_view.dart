import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:irs_admin/core/constants.dart';
import 'package:irs_admin/core/input_validator.dart';
import 'package:irs_admin/core/utilities.dart';
import 'package:irs_admin/models/UserModel.dart';
import 'package:irs_admin/widgets/input_button.dart';
import 'package:irs_admin/widgets/input_field.dart';

class UpdateUserView extends StatefulWidget {
  final String userID;
  const UpdateUserView({Key? key, required this.userID}) : super(key: key);

  @override
  _UpdateUserViewState createState() => _UpdateUserViewState();
}

List<String> sex_options = ["Male", "Female"];

class _UpdateUserViewState extends State<UpdateUserView> {
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _genderController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _addressHouseController = TextEditingController();
  final _addressStreetController = TextEditingController();
  final _contactNoController = TextEditingController();
  final _emailAddressController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String currentOption = sex_options[0];

  String _dropdownValue = "resident";

  bool verified = false;

  Map<String, dynamic> userDetails = {};

  String profile_path =
      "https://steamuserimages-a.akamaihd.net/ugc/2035117968662511260/088B73BC6D1134B00A93D3499FC5ED767EFDCDAA/?imw=512&&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false";

  void fetchDetails() async {
    userDetails = await UserModel.getUserDetails(widget.userID);
    setState(() {
      _firstNameController.text = userDetails['first_name'];
      _middleNameController.text = userDetails['middle_name'];
      _lastNameController.text = userDetails['last_name'];
      currentOption = userDetails['gender'];
      _birthdayController.text = userDetails['birthday'];
      _addressHouseController.text = userDetails['address_house'];
      _addressStreetController.text = userDetails['address_street'];
      _contactNoController.text = userDetails['contact_no'];
      _emailAddressController.text = userDetails['email'];
      _dropdownValue = userDetails['user_type'];
      profile_path = userDetails['profile_path'];
      verified = userDetails['verified'];
    });
  }

  void updateUser() async {
    InputValidator.checkFormValidity(formKey, context);
    try {
      Map<String, dynamic> user = {
        'first_name': _firstNameController.text.trim(),
        'middle_name': _middleNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'gender': currentOption,
        'birthday': _birthdayController.text.trim(),
        'address_house': _addressHouseController.text.trim(),
        'address_street': _addressStreetController.text.trim(),
        'user_type': _dropdownValue,
      };
      // Remove null or empty values from the user map

      await UserModel.updateUserDetails(widget.userID, user);
    } catch (ex) {
      print(ex);
    }

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDetails();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _genderController.dispose();
    _birthdayController.dispose();
    _addressHouseController.dispose();
    _addressStreetController.dispose();
    _contactNoController.dispose();
    _emailAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update User"),
        leading: TextButton(
          child: Icon(
            Icons.chevron_left,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    width: 500,
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(120),
                                color: Colors.grey),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(120),
                              child: Image.network(
                                profile_path,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "UID 123123123123",
                                style: subheading,
                              ),
                              (!verified)
                                  ? TextButton(
                                      onPressed: () {
                                        showDialog(
                                          useRootNavigator: true,
                                          context: context,
                                          builder: (context) {
                                            return VerifyUserDialog(
                                              user_id: widget.userID,
                                              onAction: () {},
                                            );
                                          },
                                        );
                                      },
                                      child: Text("Unverified"),
                                    )
                                  : Text(
                                      "Verified",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green,
                                      ),
                                    ),
                            ],
                          ),
                          InputField(
                            placeholder: "First Name",
                            inputType: "text",
                            controller: _firstNameController,
                            label: "First Name",
                            validator: InputValidator.requiredValidator,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InputField(
                                  placeholder: "Middle Name",
                                  inputType: "text",
                                  controller: _middleNameController,
                                  label: "Middle Name",
                                  validator: InputValidator.requiredValidator,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: InputField(
                                  placeholder: "Last Name",
                                  inputType: "text",
                                  controller: _lastNameController,
                                  label: "Last Name",
                                  validator: InputValidator.requiredValidator,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sex",
                                    style: regular,
                                  ),
                                  ListTile(
                                    contentPadding: EdgeInsets.all(4),
                                    title: const Text("Male"),
                                    leading: Radio(
                                      value: sex_options[0],
                                      groupValue: currentOption,
                                      onChanged: (value) {
                                        setState(() {
                                          currentOption = value.toString();
                                        });
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    contentPadding: EdgeInsets.all(4),
                                    title: const Text("Female"),
                                    leading: Radio(
                                      value: sex_options[1],
                                      groupValue: currentOption,
                                      onChanged: (value) {
                                        setState(() {
                                          currentOption = value.toString();
                                        });
                                      },
                                    ),
                                  )
                                ],
                              )),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: InputField(
                                  placeholder: "Birthday",
                                  inputType: "date",
                                  controller: _birthdayController,
                                  label: "Birthday",
                                  validator: InputValidator.dateValidator,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: InputField(
                                  placeholder: "House No.",
                                  inputType: "text",
                                  controller: _addressHouseController,
                                  label: "House No.",
                                  validator: InputValidator.requiredValidator,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: InputField(
                                  placeholder: "Street",
                                  inputType: "text",
                                  controller: _addressStreetController,
                                  label: "Street",
                                  validator: InputValidator.requiredValidator,
                                ),
                              ),
                            ],
                          ),
                          (_dropdownValue != 'admin')
                              ? DropdownMenu(
                                  width: 500,
                                  onSelected: (value) {
                                    setState(() {
                                      if (value is String) {
                                        _dropdownValue = value;
                                      }
                                    });
                                  },
                                  dropdownMenuEntries: <DropdownMenuEntry<
                                      String>>[
                                    DropdownMenuEntry(
                                      value: "resident",
                                      label: "Resident",
                                    ),
                                    DropdownMenuEntry(
                                      value: "tanod",
                                      label: "Tanod",
                                    ),
                                  ],
                                  initialSelection: _dropdownValue,
                                  menuStyle: MenuStyle(),
                                )
                              : SizedBox(),
                          SizedBox(
                            height: 8,
                          ),
                          InputButton(
                              label: "UPDATE",
                              function: () {
                                updateUser();
                              },
                              large: true),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 500,
                    child: Column(
                      children: [
                        Text("Reported Incidents"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VerifyUserDialog extends StatefulWidget {
  final String user_id;
  final VoidCallback onAction;
  const VerifyUserDialog(
      {Key? key, required this.user_id, required this.onAction})
      : super(key: key);

  @override
  _VerifyUserDialogState createState() => _VerifyUserDialogState();
}

class _VerifyUserDialogState extends State<VerifyUserDialog> {
  Future<String> fetchVerificationPhoto() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user_id)
          .get();

      if (userSnapshot.exists) {
        // Document exists, now convert it to a map
        Map<String, dynamic> userDetails =
            userSnapshot.data() as Map<String, dynamic>;

        return userDetails['verification_photo'];
      } else {
        // Document doesn't exist
        print('User not found');
        return '';
      }
    } catch (e) {
      print('Error retrieving user details: $e');
      return '';
    }
  }

  void verifyUser() async {
    try {
      Map<String, dynamic> user = {
        'verified': true,
      };

      await UserModel.updateUserDetails(widget.user_id, user);
      Utilities.showSnackBar("Successfully verified user", Colors.green);
      widget.onAction();
    } catch (ex) {
      print(ex);
      Utilities.showSnackBar("$ex", Colors.red);
    }

    Navigator.of(context).pop();
  }

  void rejectVerification(String reason) async {
    try {
      CollectionReference userRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user_id)
          .collection('notifications');

      await userRef.add({
        'content': "Verification rejected. Reason: $reason",
        'timestamp': FieldValue.serverTimestamp(),
      });

      Utilities.showSnackBar("Verification rejected", Colors.green);
      widget.onAction();
    } catch (ex) {
      print(ex);
      Utilities.showSnackBar("$ex", Colors.red);
    }

    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // content: Padding(
      //   padding: EdgeInsets.all(16),
      //   child: SizedBox(
      //     height: 300,
      //     width: 500,
      //     child: Column(
      //       children: [
      //         Container(
      //           width: 500,
      //           height: 300,
      //           color: Colors.grey,
      //         ),
      //         SizedBox(
      //           height: 8,
      //         ),

      //       ],
      //     ),
      //   ),
      // ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder(
              future: fetchVerificationPhoto(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  String photo_url = snapshot.data!;
                  if (photo_url == null || photo_url == "") {
                    return Container(
                      width: 500,
                      height: 300,
                      color: Colors.grey,
                      child: Center(child: Icon(Icons.error)),
                    );
                  } else {
                    return Container(
                      width: 500,
                      height: 300,
                      color: Colors.grey,
                      child: Image.network(
                        photo_url,
                        fit: BoxFit.contain,
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: InputButton(
                  label: "REJECT",
                  function: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final _reasonController = TextEditingController();
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InputField(
                                placeholder: "Rejection reason...",
                                inputType: "message",
                                controller: _reasonController,
                                label: "Reason for rejection",
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancel")),
                            TextButton(
                                onPressed: () {
                                  if (_reasonController.text.isEmpty) {
                                    Utilities.showSnackBar(
                                        "Please provide a reason", Colors.red);
                                    return;
                                  }
                                  rejectVerification(
                                      _reasonController.text.trim());
                                },
                                child: Text("Submit")),
                          ],
                        );
                      },
                    );
                  },
                  large: false,
                  color: Colors.red,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                  child: InputButton(
                label: "Verify",
                function: () {
                  verifyUser();
                },
                large: false,
                color: Colors.green,
              )),
            ],
          )
        ],
      ),
    );
  }
}
