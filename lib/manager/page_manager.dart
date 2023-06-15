import 'package:avukapp/model/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constant/constant.dart';
import '../screens/favorite/favorite_page.dart';
import '../screens/home/home_page.dart';
import '../screens/meeting/lawyer/lawyer_meet_request_screen.dart';
import '../screens/meeting/member/member_meeting_screen.dart';
import '../screens/profile/profile_detail/about_detail/about.dart';
import '../screens/profile/profile_detail/profile_pages/place_an_ad/place_an_ad_body.dart';
import '../screens/profile/profile_detail/terms_conditions_detail/terms_conditions.dart';
import '../screens/profile/profile_page.dart';
import '../viewmodel/user_view_model.dart';
import 'navigator_manager.dart';

// ignore: must_be_immutable
class MyPageManager extends StatefulWidget {
  const MyPageManager({super.key});

  @override
  State<MyPageManager> createState() => _MyPageManagerState();
}

class _MyPageManagerState extends State<MyPageManager> {
  int selectinIndex = 0;
  final double _bottomBarHeight = 60;
  final int _duration = 600;
  final double _animateContainerWitdth = 74;
  NavigatorManager pagePushManager = NavigatorManager();
  @override
  void initState() {
    super.initState();
  }

  String getAppName(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return "Ana Sayfa";

      case 1:
        return "Favoriler";

      case 2:
        return "Profil Sayfası";
      default:
        return "-";
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserViewModel>(context, listen: false);

    PageController myPage = PageController(initialPage: selectinIndex);
    return Scaffold(
      drawer: selectinIndex == 0
          ? drawerHamburgerMenu(
              userProvider.user!,
              context,
              userProvider,
            )
          : null,
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          getAppName(selectinIndex),
          style: GoogleFonts.cutiveMono(
            color: kCreamColor,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: kNavyBlueColor,
        centerTitle: true,
      ),
      body: PageView(
        // physics: const NeverScrollableScrollPhysics(),
        controller: myPage,
        onPageChanged: (value) {
          setState(() {
            selectinIndex = value;
          });
        },
        children: const [
          MyHomePage(),
          FavoritePage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: homeBottomBar(myPage),
    );
  }

  Drawer drawerHamburgerMenu(
    UserModel user,
    BuildContext context,
    UserViewModel userViewModel,
  ) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              user.userName!,
              style: const TextStyle(color: Colors.black),
            ),
            accountEmail: Text(
              user.email!,
              style: const TextStyle(color: Colors.black),
            ),
            currentAccountPicture: SizedBox(
              width: 100,
              height: 50,
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.profilImgURL ?? ''),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: NetworkImage(
                    "https://i.pinimg.com/736x/1a/61/10/1a611036f4275ca78c58277e1fb260b6.jpg",
                  ),
                  fit: BoxFit.cover),
            ),
          ),
          if (user.isLawyer == 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: kNavyBlueColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.receipt_long_outlined,
                    color: kCreamColor,
                    size: 26,
                  ),
                  title: const Text(
                    "İlan Ayarları",
                    style: TextStyle(
                      color: kCreamColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    pagePushManager.navigatToWidget(
                      context,
                      const PlaceAnAdBody(),
                    );
                  },
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Container(
              decoration: BoxDecoration(
                color: kNavyBlueColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.people,
                  color: kCreamColor,
                ),
                title: const Text(
                  "Randevularım",
                  style: TextStyle(
                    color: kCreamColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  // Randevular butonuna tıklandığında
                  // üye ise 0
                  // avukat ise 1 durumu oluyor.
                  if (user.isLawyer == 0) {
                    pagePushManager.navigatToWidget(
                      context,
                      const MemberMeetingScreen(),
                    );
                  } else {
                    pagePushManager.navigatToWidget(
                      context,
                      LawyerMeetRewuestScreen(
                        avukatName: user.userName!,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Container(
              decoration: BoxDecoration(
                color: kNavyBlueColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.people,
                  color: kCreamColor,
                ),
                title: const Text(
                  "Hakkında",
                  style: TextStyle(
                    color: kCreamColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  pagePushManager.navigatToWidget(
                    context,
                    const AboutPage(),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Container(
              decoration: BoxDecoration(
                color: kNavyBlueColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.terminal_sharp,
                  color: kCreamColor,
                ),
                title: const Text(
                  "Şartlar & Koşullar",
                  style: TextStyle(
                    color: kCreamColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  pagePushManager.navigatToWidget(
                    context,
                    const TermsConditionsPage(),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Container(
              decoration: BoxDecoration(
                color: kNavyBlueColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.exit_to_app,
                  color: kCreamColor,
                ),
                title: const Text(
                  "Çıkış",
                  style: TextStyle(
                    color: kCreamColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: SizedBox(
                          height: 90,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Çıkış Yapmak istiyor musun?",
                                style: TextStyle(
                                  color: kNavyBlueColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        userViewModel.singOut();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kNavyBlueColor,
                                      ),
                                      child: const Text(
                                        "Evet",
                                        style: TextStyle(
                                          color: kCreamColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kNavyBlueColor,
                                      ),
                                      child: const Text(
                                        "Hayır",
                                        style: TextStyle(
                                          color: kCreamColor,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding homeBottomBar(PageController myPage) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
          color: kNavyBlueColor,
        ),
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: _bottomBarHeight,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: _duration),
                  width: _animateContainerWitdth,
                  decoration: BoxDecoration(
                    color: selectinIndex == 0 ? kCreamColor : null,
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        selectinIndex = 0;
                        myPage.jumpToPage(selectinIndex);
                      });
                    },
                    icon: Icon(
                      Icons.home,
                      color: selectinIndex == 0 ? kNavyBlueColor : kCreamColor,
                      size: 32,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: _duration),
                  width: _animateContainerWitdth,
                  decoration: BoxDecoration(
                    color: selectinIndex == 1 ? kCreamColor : null,
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            selectinIndex = 1;
                            myPage.jumpToPage(selectinIndex);
                          });
                        },
                        icon: Icon(
                          Icons.favorite,
                          color:
                              selectinIndex == 1 ? kNavyBlueColor : kCreamColor,
                          size: 32,
                        ),
                      ),
                      // Positioned(
                      //   bottom: 26,
                      //   left: 50,
                      //   child: Container(
                      //     width: 22,
                      //     height: 22,
                      //     decoration: BoxDecoration(
                      //       color: kWineRedColor,
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     child: const Center(
                      //       child: Text(
                      //         "1",
                      //         style: TextStyle(color: kCreamColor),
                      //         textAlign: TextAlign.center,
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
                // AnimatedContainer(
                //   duration: Duration(milliseconds: _duration),
                //   width: _animateContainerWitdth,
                //   decoration: BoxDecoration(
                //     color: selectinIndex == 2 ? kCreamColor : null,
                //     borderRadius: BorderRadius.circular(36),
                //   ),
                //   child: IconButton(
                //     onPressed: () {
                //       setState(() {
                //         selectinIndex = 2;
                //         myPage.jumpToPage(selectinIndex);
                //       });
                //     },
                //     icon: Icon(
                //       Icons.notifications,
                //       color: selectinIndex == 2 ? kNavyBlueColor : kCreamColor,
                //       size: 32,
                //     ),
                //   ),
                // ),
                AnimatedContainer(
                  duration: Duration(milliseconds: _duration),
                  width: _animateContainerWitdth,
                  decoration: BoxDecoration(
                    color: selectinIndex == 2 ? kCreamColor : null,
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        selectinIndex = 2;
                        myPage.jumpToPage(selectinIndex);
                      });
                    },
                    icon: Icon(
                      Icons.person,
                      color: selectinIndex == 2 ? kNavyBlueColor : kCreamColor,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
