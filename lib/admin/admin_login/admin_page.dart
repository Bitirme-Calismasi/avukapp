import 'package:avukapp/constant/constant.dart';
import 'package:flutter/material.dart';
import '../../constant/app_bar_widget.dart';
import '../../manager/navigator_manager.dart';
import '../../widgets/custom_button_widget.dart';
import '../admin_onay/admin_panel.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final GlobalKey<FormState> _formAdminKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool passwordVisible = true;

  void changeVisible() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appTitle: "Yönetici Giriş",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formAdminKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(
                  labelText: "Yönetici E-posta",
                  hintText: "Yönetici e-postasını giriniz...",
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(
                  labelText: "Yönetici Şifre",
                  hintText: "Yönetici şifresini giriniz...",
                  iconButton: IconButton(
                    onPressed: changeVisible,
                    icon: passwordVisible == true
                        ? const Icon(
                            Icons.visibility_off,
                            color: kNavyBlueColor,
                          )
                        : const Icon(
                            Icons.visibility,
                            color: kNavyBlueColor,
                          ),
                  ),
                ),
                obscureText: passwordVisible,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              GestureDetector(
                child: const CustomButtonWidget(
                  buttonName: "Giriş Yap",
                ),
                onTap: () {
                  _formSubmit(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required String labelText,
    Widget? iconButton,
  }) {
    return InputDecoration(
      suffixIcon: iconButton,
      labelText: labelText,
      hintText: hintText,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: kNavyBlueColor,
          width: 1.5,
        ),
        gapPadding: 10,
      ),
      hintStyle: const TextStyle(color: kNavyBlueColor),
      labelStyle: const TextStyle(color: kNavyBlueColor),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: kNavyBlueColor,
          width: 1.5,
        ),
        gapPadding: 10,
      ),
    );
  }

  void _formSubmit(BuildContext context) {
    if (_formAdminKey.currentState!.validate()) {
      _formAdminKey.currentState!.save();
      if (emailController.text == 'avukap@avukap.com' &&
          passwordController.text == '123456') {
        emailController.clear();
        passwordController.clear();
        NavigatorManager().navigatToWidget(
          context,
          const AdminPanelPage(),
        );
      }
    }
  }
}
