// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sfs_editor/constants/color.dart';
import 'package:sfs_editor/constants/strings.dart';
import 'package:sfs_editor/core/in_app_purchase.dart';
import 'package:sfs_editor/screens/edit_option_screen.dart';
import 'package:sfs_editor/screens/settings_screen.dart';
import 'package:sfs_editor/services/dark_mode_service.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key, this.isEditor});
  final bool? isEditor;

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  bool _isFetchOffersCalled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!(InAppPurchase.isPro || InAppPurchase.isProAI)) {
      if (!_isFetchOffersCalled) {
        _isFetchOffersCalled = true;
        Future.delayed(const Duration(seconds: 2)).then(
          (_) async {
            bool hasInternet = await checkInternetConnection();
            if (hasInternet) {
              InAppPurchase.fetchOffers(context);
            } else {
              showNoInternetDialog(context);
            }
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor:
              themeProvider.isDarkMode ? darkMoodColor : Colors.white,
          foregroundColor:
              themeProvider.isDarkMode ? Colors.white : Colors.black,
          title: Row(
            children: [
              Image.asset(
                  'assets/starryImages/snaplet-logo high small3 edited.png',
                  width: 35),
              const Text('Snaplet',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                bool hasInternet = await checkInternetConnection();
                if (hasInternet) {
                  InAppPurchase.fetchOffers(context);
                } else {
                  showNoInternetDialog(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    themeProvider.isDarkMode ? Colors.white : Colors.black,
                foregroundColor:
                    themeProvider.isDarkMode ? Colors.black : Colors.white,
                padding: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(
                  InAppPurchase.isPro || InAppPurchase.isProAI
                      ? 'Pro'
                      : 'Get Pro!',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const SettingsScreen()));
              },
              icon: const Icon(Icons.settings),
            ),
            const SizedBox(width: 5),
          ],
          automaticallyImplyLeading: false,
        ),
        body: const EditOptionScreen());
  }
}
