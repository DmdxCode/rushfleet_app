import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spatch_flutter/components/drawer_list_tile.dart';
import 'package:spatch_flutter/components/footer_rushfleet_logo.dart';
import 'package:spatch_flutter/pages/account_page.dart';
import 'package:spatch_flutter/pages/history_page.dart';
import 'package:spatch_flutter/pages/intro_page.dart';
import 'package:spatch_flutter/pages/request_page.dart';
import 'package:spatch_flutter/pages/wallet_page.dart';
import 'package:intl/intl.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String? username;
  int balance = 0;

  void signOut() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => IntroPage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (username == null) {
      getUsername();
      loadWalletBalance();
    }
  }

  Future<void> loadWalletBalance() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final rawBalance = userDoc['wallet_balance'] ?? 0;
        final int parsedBalance = rawBalance is int
            ? rawBalance
            : (rawBalance is double ? rawBalance.toInt() : 0);

        if (mounted) {
          setState(() {
            balance = parsedBalance;
          });
        }
      }
    } catch (e) {
      debugPrint("Error loading wallet balance: $e");
    }
  }

  Future<void> getUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("user")
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          username = "${userDoc['first_name']} ${userDoc['last_name']}";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: 400,
              decoration: BoxDecoration(
                color: Color(0xFF12AA6C),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Hi, 👋",
                      style: TextStyle(
                          fontSize: 23,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      username ?? "",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AccountPage()));
                      },
                      child: Text(
                        "View Profile",
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 100,
              width: 400,
              decoration: BoxDecoration(
                color: Color(0xFF061F16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Wallet Balance",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "NGN ${NumberFormat("#,##0").format(balance)}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WalletPage()));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: SvgPicture.asset(
                              "lib/svg/add2.svg",
                              colorFilter: ColorFilter.mode(
                                  Color(0XFFFFB947), BlendMode.color),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            DrawerListTile(
              icon: "lib/images/result.png",
              text: "Request",
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RequestPage(),
                  ),
                );
              },
            ),
            DrawerListTile(
              icon: "lib/images/wallet.png",
              text: "Wallet",
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WalletPage(),
                  ),
                );
              },
            ),
            DrawerListTile(
              icon: "lib/images/history.png",
              text: "History",
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryPage()),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                  leading: Image.asset(
                    "lib/images/user.png",
                    height: 20,
                    width: 20,
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AccountPage()),
                    );
                  },
                  title: Text("Account",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black))),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 1,
                      color: Colors
                          .grey.shade400), // Adjust border thickness & color
                  bottom: BorderSide(
                    width: 1,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              child: ListTile(
                onTap: signOut,
                leading: Icon(
                  size: 20,
                  color: Colors.black,
                  Icons.logout,
                ),
                title: Text("Logout",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border(
                  // Adjust border thickness & color
                  bottom: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              child: ListTile(
                leading: Icon(
                  size: 20,
                  Icons.info_outline,
                  color: Colors.black,
                ),
                title: Text("Contact",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            SizedBox(
              height: 70,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  FooterRushfleetLogo(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
