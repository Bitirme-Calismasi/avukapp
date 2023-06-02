import 'package:flutter/material.dart';

import '../constant/constant.dart';
import '../screens/landing_screen.dart';
import '../screens/register/registration.dart';

class OnboardAligmenButtons extends StatelessWidget {
  const OnboardAligmenButtons({
    super.key,
  });

  final double containerHeight = 56;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 20,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegistrationScreen(),
                    ),
                  );
                },
                child: Container(
                  height: containerHeight,
                  decoration: BoxDecoration(
                    color: kNavyBlueColor,
                    borderRadius: BorderRadius.circular(containerHeight / 2),
                  ),
                  child: const Center(
                    child: Text(
                      "Kayıt Ol",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: kMyFontSizelow,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LandingPage(),
                    ),
                  );
                },
                child: Container(
                  height: containerHeight,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(containerHeight / 2),
                  ),
                  child: const Center(
                    child: Text(
                      "Giriş",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: kMyFontSizelow,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
