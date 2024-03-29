import 'package:avukapp/constant/constant.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/user_view_model.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController forgetPasswordController = TextEditingController();
  @override
  void dispose() {
    forgetPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              const Text(
                "Şifremi Unuttum",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                alignment: Alignment.center,
                height: 250,
                child: Lottie.asset("assets/forgot.json"),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30.0),
                child: TextFormField(
                  controller: forgetPasswordController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: "E-Posta",
                      enabledBorder: OutlineInputBorder()),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: kNavyBlueColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 40.0), // Düğme içi boşluk ayarları
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Düğme kenarlık şekli
                    ),
                  ),
                  onPressed: () async {
                    var forgotpassword = forgetPasswordController.text.trim();
                    var userModel =
                        Provider.of<UserViewModel>(context, listen: false);
                    userModel.forgotPassword(forgotpassword);
                  },
                  child: const Text("Gönder"))
            ],
          ),
        ),
      ),
    );
  }
}
