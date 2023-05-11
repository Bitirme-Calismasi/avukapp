import 'package:flutter/material.dart';

Widget get dividerWidget => SizedBox(
      width: 250, // Bölücünün genişliği 200 piksel olacak
      child: Divider(
        thickness: 2, // Bölücünün kalınlığı 2 piksel olacak
        color: Colors.grey[300], // Bölücünün rengi gri tonunda olacak
      ),
    );
Widget sizedBoxWidget(double height) => const SizedBox(
      height: 10,
    );

Widget textWidget(String text) => Text(
      text,
      style: const TextStyle(fontSize: 15, color: Colors.grey),
    );

Container profileImageContainer(String imageUrl) {
  return Container(
    height: 200,
    width: 200,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      image: DecorationImage(
        image: NetworkImage(imageUrl),
        fit: BoxFit.cover,
      ),
      border: Border.all(
        color: Colors.white,
        width: 5,
      ),
    ),
  );
}

Text nameText(String userName) {
  return Text(
    userName.toUpperCase(),
    style: const TextStyle(
        fontWeight: FontWeight.w400, fontSize: 20, color: Colors.black),
  );
}

SizedBox mailSizedboxAndTextForm(
    TextEditingController _emailController) {
  return SizedBox(
    width: 300,
    height: 40,
    child: TextFormField(
      controller: _emailController,
      //initialValue: ,
      textAlign: TextAlign.center,

      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your email';
        } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
      onSaved: (value) {
        _emailController.text = value!;
        debugPrint(_emailController.text);
      },
    ),
  );
}

SizedBox aboutSizedboxAndTextForm(
    TextEditingController _aboutController) {
  return SizedBox(
    width: 300,
    height: 30,
    child: TextFormField(
      controller: _aboutController,
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 15, color: Colors.blueGrey),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Mail alanı boş bırakılamaz';
        }
        return null;
      },
      onSaved: (value) {
        _aboutController.text = value!;
        debugPrint(_aboutController.text);
      },
    ),
  );
}

SizedBox passwordSizedboxAndTextForm(TextEditingController _passwordController,
    bool _passwordVisible, Function setstatePassword, bool editmood) {
  return SizedBox(
    width: 300,
    height: 30,
    child: TextFormField(
      enabled: editmood,
      controller: _passwordController,
      textAlign: TextAlign.center,
      obscureText: !_passwordVisible,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 15, color: Colors.blueGrey),
      decoration: InputDecoration(
        suffixIcon: editmood
            ? IconButton(
                icon: _passwordVisible
                    ? Icon(Icons.visibility)
                    : Icon(Icons.visibility_off),
                onPressed: (() {
                  setstatePassword();
                }),
              )
            : SizedBox(),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Password alanı boş bırakılamaz';
        }
        return null;
      },
      onSaved: (value) {
        _passwordController.text = value!;
      },
    ),
  );
}
