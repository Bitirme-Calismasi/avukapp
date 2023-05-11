import 'package:avukapp/constant/constant.dart';
import 'package:avukapp/manager/navigator_manager.dart';
import 'package:avukapp/model/user.dart';
import 'package:avukapp/screens/login/login_with_phone.dart';
import 'package:avukapp/screens/register/registration.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../admin/admin_login/admin_page.dart';
import '../../viewmodel/user_view_model.dart';
import '../../widgets/social_button.dart';
import '../landing_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset:
          false, //textfielda basıldıgında ekranın tamamının yukarıya doğru sıkışmasını engeller

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: width / 2,
            height: height / 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kCreamColor,
              border: Border.all(color: kNavyBlueColor, width: 1),
            ),
            child: const Center(
                child: Text(
              "Giriş Yap",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
          ),
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'E-posta',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Lütfen e-postanızı girin';
                        } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Lütfen geçerli bir e-posta girin';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: height / 65,
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          labelText: 'Şifre',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          suffixIcon: IconButton(
                            icon: _passwordVisible
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          )),
                      obscureText: !_passwordVisible,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Lütfen şifrenizi girin';
                        } else if (value.length < 6) {
                          return 'Şifre en az 6 karakterden oluşmalı';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    PressButtonWidget(
                      buttonText: 'Giriş',
                      onPress: () {
                        userLogin();
                        //login();
                      },
                      buttonColor: kNavyBlueColor,
                      buttonHeight: 50,
                      textColor: kWhiteColor,
                      buttonWeight: 250,
                    ),
                    const SizedBox(height: 10),
                    SocialButtonWidget(
                      buttonText: "Google ile giriş yap",
                      buttonIcon: const Icon(
                        MdiIcons.googlePlus,
                        color: kWhiteColor,
                      ),
                      onPress: () {
                        singInWithGoogle();
                      },
                      buttonHeight: 40,
                      buttonWidth: width,
                    ),
                    SocialButtonWidget(
                      buttonText: "Telefon ile giriş yap",
                      buttonIcon: const Icon(
                        MdiIcons.phone,
                        color: kWhiteColor,
                      ),
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const LoginWithPhoneScreen(),
                            ));
                      },
                      buttonHeight: 40,
                      buttonWidth: width,
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistrationScreen(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Text(
                            "Kayıt Ol",
                            style: TextStyle(
                              color: kWineRedColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        NavigatorManager()
                            .navigatToWidget(context, const AdminLoginPage());
                      },
                      child: const Text(
                        "Admin Giriş",
                        style: TextStyle(
                          color: kNavyBlueColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> showError(String message) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Kapat",
                    ))
              ],
              title: const Text("Hata!"),
              // contentPadding: EdgeInsets.all(10),
              content: Text(message),
            ));
  }

  void userLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        var userModel = Provider.of<UserViewModel>(context, listen: false);
        final UserModel user = await userModel.singInWithEmailAndPass(
            emailController.text, passwordController.text);
        debugPrint('EMAİL İLE GİRİŞ YAPMA BAŞARILI111');
      } catch (e) {
        debugPrint('LOGİN İŞLEMİNDE HATA11111  : ${e.toString()}');
      }
    }
  }

  void singInWithGoogle() async {
    try {
      final usermodel = Provider.of<UserViewModel>(context, listen: false);
      UserModel user = await usermodel.singInWithGoogle();
      debugPrint(
          'GOOGLE GMAİL İLE OTURUM ACAN KULLANICI ${user.userID.toString()}');
    } catch (e) {
      debugPrint('GOOGLE GİRİŞ YAPMA SEÇENEGİ HATA CIKTI ${e.toString()}');
    }
  }
}
