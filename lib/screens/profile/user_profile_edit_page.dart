import 'package:avukapp/constant/constant.dart';
import 'package:avukapp/viewmodel/user_view_model.dart';
import 'package:avukapp/widgets/social_button.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constant/app_bar_widget.dart';

class UserProfileEditPage extends StatefulWidget {
  UserProfileEditPage({super.key});

  @override
  State<UserProfileEditPage> createState() => _UserProfileEditPageState();
}

class _UserProfileEditPageState extends State<UserProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _newPassController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserViewModel>(context, listen: false);
    _emailController.text = user.user!.email.toString();
    _nameController.text = user.user!.userName.toString();
    _passController.text = '000000';
    _newPassController.text = '000000';

    return Scaffold(
      appBar: const CustomAppBar(
        appTitle: "Profil Düzenle",
        backButtonIsActive: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Bu alan Boş Geçileemez';
                      }
                    },
                    controller: _nameController,
                    decoration: InputDecoration(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.account_circle,
                              color: kNavyBlueColor,
                              size: 40,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Ad-Soyad',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        border: const OutlineInputBorder(),
                        hintText: 'Ad-Soyad'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lütfen e-postanızı girin';
                      } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Lütfen geçerli bir e-posta girin';
                      }
                      return null;
                    },
                    controller: _emailController,
                    decoration: InputDecoration(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.email,
                              color: kNavyBlueColor,
                              size: 40,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Email',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        border: const OutlineInputBorder(),
                        hintText: 'Email'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value!.length < 6) {
                        return 'Şifrenizi Kontrol Edin';
                      }
                    },
                    controller: _passController,
                    decoration: InputDecoration(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.password_outlined,
                              color: kNavyBlueColor,
                              size: 40,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Eski Şifre',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        border: const OutlineInputBorder(),
                        hintText: 'Eski şifre'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value!.length < 6) {
                        return 'Şifreniz en az 6 karakter olmalı';
                      }
                    },
                    controller: _newPassController,
                    decoration: InputDecoration(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.password_outlined,
                              color: kNavyBlueColor,
                              size: 40,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Yeni Şifre',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        border: const OutlineInputBorder(),
                        hintText: 'Yeni şifre'),
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    PressButtonWidget(
                      buttonText: 'Vazgeç',
                      buttonColor: kNavyBlueColor,
                      textColor: kCreamColor,
                      buttonHeight: 40,
                      buttonWeight: 150,
                      onPress: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    PressButtonWidget(
                      buttonText: 'Onayla',
                      buttonColor: kNavyBlueColor,
                      textColor: kCreamColor,
                      buttonHeight: 40,
                      buttonWeight: 150,
                      onPress: () {
                        _formSubmit();
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _formSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool name = false;
      bool email = false;
      bool pass = false;
      bool onPopChange = false;
      final user = Provider.of<UserViewModel>(context, listen: false);
      String userid = user.user!.userID!;
      if (_nameController.text != user.user!.userName) {
        name = await user.updateUserName(userid, _nameController.text);
        onPopChange = name;
        debugPrint('DEĞİŞTİ İSİM');
      }
      if (_emailController.text != user.user!.email) {
        email = await user.updateEmail(userid, _emailController.text);
        onPopChange = email;
        debugPrint('DEĞİŞTİ ŞİFRE');
      }
      if (_passController.text != '000000' &&
          _newPassController.text != '000000') {
        pass = await user.changeEmailAuthPass(
            _passController.text, _newPassController.text);
        debugPrint('DEĞİŞTİ PASS');
      }
      if (_passController.text == '000000' &&
          _newPassController.text == '000000' &&
          _nameController.text == user.user!.userName &&
          _emailController.text == user.user!.email) {
        // ignore: use_build_context_synchronously
        await CoolAlert.show(
            backgroundColor: kNavyBlueColor,
            barrierDismissible: false,
            title: 'Düzenleme',
            context: context,
            type: CoolAlertType.warning,
            text: 'Herhangi bir değişiklik yapılmadı!!',
            autoCloseDuration: const Duration(seconds: 2),
            confirmBtnText: ' ',
            confirmBtnColor: Colors.white);
      }
      if (name || pass || email) {
        // ignore: use_build_context_synchronously
        await CoolAlert.show(
            backgroundColor: kNavyBlueColor,
            barrierDismissible: false,
            title: 'Güncelleme',
            context: context,
            type: CoolAlertType.success,
            text: ' Başarı ile Güncellendi',
            autoCloseDuration: const Duration(seconds: 2),
            confirmBtnText: ' ',
            confirmBtnColor: Colors.white);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop(onPopChange);
      }
    }
  }
}


/*

 await CoolAlert.show(
                backgroundColor: kNavyBlueColor,
                barrierDismissible: false,
                title: 'Güncelleme',
                context: context,
                type: CoolAlertType.success,
                text: 'Şifre Başarı ile Güncellendi',
                autoCloseDuration: const Duration(seconds: 2),
                confirmBtnText: ' ',
                confirmBtnColor: Colors.white);
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();


 */