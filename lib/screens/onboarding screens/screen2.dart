import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sfs_editor/constants/color.dart';
import 'package:sfs_editor/services/dark_mode_service.dart';
import 'package:sfs_editor/widgets/onboarding%20widgets/background_screen2_wedget.dart';

class ScreenConsistance2 extends StatelessWidget {
  const ScreenConsistance2({super.key, required this.nextPage});
  final VoidCallback nextPage;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.isDarkMode? darkMoodColor : Colors.white,
      body: Stack(
        children: [
          const BackgroundScreen2(),
          Padding(
            padding: const EdgeInsets.only(top: 120, left: 94),
            child: Column(
              children: [
                Text(
                  'Send Live Snaps!',
                  style: TextStyle(
                      color: themeProvider.isDarkMode? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Text(
                      'With Livroll, you can send pictures and videos from camera roll as a live snap on\n                            SnapChat.\n          You can send the ai generated\n                  media as a live snap ',
                      style: TextStyle(
                          fontSize: 15,
                          color: themeProvider.isDarkMode? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: nextPage,
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(350, 60),
                      backgroundColor: themeProvider.isDarkMode? Colors.white : Colors.black,
                    ),
                    child: Row(
                      children: [
                        const Spacer(
                          flex: 3,
                        ),
                        Text(
                          'Continue',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.isDarkMode? Colors.black : Colors.white,),
                        ),
                        const Spacer(
                          flex: 2,
                        ),
                        Icon(
                          Icons.arrow_forward_outlined,
                          size: 30,
                          color: themeProvider.isDarkMode? Colors.black : Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'By proceeding, you accept our Terms of Use and Privacy Policy',
                    style: TextStyle(
                      fontSize: 13,
                      color: themeProvider.isDarkMode? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
