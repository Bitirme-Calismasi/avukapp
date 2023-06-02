import 'package:avukapp/constant/constant.dart';
import 'package:avukapp/screens/login/login.dart';
import 'package:avukapp/widgets/social_button.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../model/user.dart';
import '../../viewmodel/user_view_model.dart';
import '../exception/login-exception.dart';
import 'lawyer_register_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final String logoUrl = "assets/images/justice.svg";

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late bool _passwordVisible;
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _formSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        var userModel = Provider.of<UserViewModel>(context, listen: false);
        final UserModel user = await userModel.createWithUserEmailAndPass(
          _emailController.text,
          _passwordController.text,
          _nameController.text,
        );
        debugPrint('EMAİL İLE KAYIT OLMA BAŞARILI');
        // ignore: use_build_context_synchronously
        await CoolAlert.show(
            backgroundColor: kNavyBlueColor,
            barrierDismissible: false,
            title: 'Başarılı!',
            context: context,
            type: CoolAlertType.success,
            text: 'Kayıt İşleminiz Tamamlandı...\n Anasayfaya Gidiliyor',
            autoCloseDuration: const Duration(seconds: 4),
            confirmBtnText: ' ',
            confirmBtnColor: Colors.white);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      } on FirebaseAuthException catch (e) {
        String temp = LoginException.exception(e.toString());
        Fluttertoast.showToast(
            msg: temp,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red.shade300,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  radius: 50,
                  child: SvgPicture.asset(
                    logoUrl,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    const Text(
                      "AvukApp",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text("Hukuki Danışmanlık Servisi"),
                    SizedBox(
                      height: height / 30,
                    ),
                    const Text(
                      "Kayıt Ol",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: height / 90,
                              ),
                              Wrap(
                                runSpacing: height / 65,
                                children: [
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      labelText: 'İsim',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your name';
                                      }
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      labelText: 'E-posta',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your email';
                                      } else if (!RegExp(r'\S+@\S+\.\S+')
                                          .hasMatch(value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: !_passwordVisible,
                                    decoration: InputDecoration(
                                        labelText: 'Şifre',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: _passwordVisible
                                              ? const Icon(Icons.visibility)
                                              : const Icon(
                                                  Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              _passwordVisible =
                                                  !_passwordVisible;
                                            });
                                          },
                                        )),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your password';
                                      } else if (value.length < 6) {
                                        return 'Password must be at least 6 characters long';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: height / 25),
                                  PressButtonWidget(
                                    buttonColor: kNavyBlueColor,
                                    buttonHeight: height / 15,
                                    buttonWeight: width,
                                    buttonText: 'Kayıt Ol',
                                    onPress: () {
                                      _formSubmit(context);
                                    },
                                    textColor: kWhiteColor,
                                  ),
                                ],
                              ),
                              Center(
                                child: MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()));
                                  },
                                  child: const Text(
                                    'Oturum aç',
                                    style: TextStyle(color: kWineRedColor),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height / 60,
                              ),
                              PressButtonWidget(
                                  buttonText:
                                      "Avukat mısın?\nHemen bize katıl!",
                                  buttonColor: kNavyBlueColor,
                                  textColor: kWhiteColor,
                                  buttonHeight: height / 10,
                                  buttonWeight: width,
                                  onPress: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LawyerRegisterPage()));
                                  })
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
