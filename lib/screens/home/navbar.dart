import 'package:avukapp/screens/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/user_view_model.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late FirebaseAuth auth;

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint(auth.currentUser!.displayName);
    final user = Provider.of<UserViewModel>(context, listen: false);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              auth.currentUser!.displayName.toString().toUpperCase(),
              style: const TextStyle(color: Colors.black),
            ),
            accountEmail: Text(
              auth.currentUser!.email.toString(),
              style: const TextStyle(color: Colors.black),
            ),
            currentAccountPicture: SizedBox(
              width: 100,
              height: 50,
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.user!.profilImgURL!),
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: NetworkImage(
                        "https://i.pinimg.com/736x/1a/61/10/1a611036f4275ca78c58277e1fb260b6.jpg"),
                    fit: BoxFit.cover)),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            title: Text("Settings"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
            title: Text("Exit"),
            onTap: () {
              showExitPopup(context);
              /* Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FirebaseService()));*/
            },
          ),
        ],
      ),
    );
  }

  Future showExitPopup(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Do you want to exit?"),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            print('yes selected');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Text("Yes"),
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          print('no selected');
                          Navigator.of(context).pop();
                        },
                        child:
                            Text("No", style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                            //primary: ColorConstants.instance.flower,
                            ),
                      ))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
