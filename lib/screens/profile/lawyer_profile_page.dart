import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/user_view_model.dart';
import 'common_widgets.dart';

class LawyerProfilePage extends StatefulWidget {
  const LawyerProfilePage({super.key});

  @override
  State<LawyerProfilePage> createState() => _LawyerProfilePageState();
}

class _LawyerProfilePageState extends State<LawyerProfilePage> {
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
                                    icon: const Center(
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
                const SizedBox(
                  height: 20,
                ),
                textWidget("E-POSTA ADRESİ"),
                mailSizedboxAndTextForm(_emailController, editMood),
                const SizedBox(
                  height: 20,
                ),
                textWidget("HAKKINDA"),
                aboutSizedboxAndTextForm(_aboutController, editMood),
                const SizedBox(
                  height: 30,
                ),
                textWidget("Uzmanlık Alanı"),
                SizedBox(
                    width: 300,
                    height: 40,
                    child: TextFormField(
                      enabled: editMood,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black),
                    )),
                const SizedBox(
                  height: 40,
                ),
                textWidget("BARO SİCİL NUMARASI"),
                SizedBox(
                    width: 300,
                    height: 35,
                    child: TextFormField(
                      enabled: editMood,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.blueGrey),
                    )),
                const SizedBox(
                  height: 30,
                ),
                textWidget("ŞİFRE"),
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
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
