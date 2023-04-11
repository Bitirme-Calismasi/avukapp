import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/user_view_model.dart';
import 'common_widgets.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late final _emailController = TextEditingController();
  late final _aboutController = TextEditingController();
  late final _passwordController = TextEditingController();

  bool _passwordVisible = false;
  late File fileToUpload;
  late String downloadUrl;
  bool editMood = false;

  @override
  void dispose() {
    _emailController.dispose();
    _aboutController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void visibilityPassword() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserViewModel>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    profileImageContainer(),
                    Positioned(
                        top: 5,
                        right: 8,
                        child: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          radius: 16,
                          child: IconButton(
                            icon: editMood
                                ? Icon(Icons.add_a_photo)
                                : IconButton(
                                    onPressed: () {},
                                    icon: Center(
                                      child: Icon(
                                        Icons.edit,
                                        size: 27,
                                      ),
                                    ),
                                  ),
                            onPressed: () {
                              setState(() {
                                editMood = true;
                              });
                            },
                          ),
                        ))
                  ],
                ),
                sizedBoxWidget(30),
                nameText(user),
                sizedBoxWidget(60),
                textWidget("E-POSTA ADRESİ"),
                mailSizedboxAndTextForm(_emailController, editMood),
                sizedBoxWidget(10),
                textWidget("HAKKINDA"),
                aboutSizedboxAndTextForm(_aboutController, editMood),
                sizedBoxWidget(20),
                textWidget("ŞİFRE"),
                sizedBoxWidget(10),
                Center(
                  child: passwordSizedboxAndTextForm(_passwordController,
                      _passwordVisible, visibilityPassword, editMood),
                ),
                sizedBoxWidget(20),
                editMood
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                editMood = false;
                              });
                            },
                            child: const Text(
                              'Vazgeç',
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                // Kaydedilecek verileri burada işleyebilirsiniz
                              }
                            },
                            child: const Text(
                              'Kaydet',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
