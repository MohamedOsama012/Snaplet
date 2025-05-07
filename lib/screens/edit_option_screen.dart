// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sfs_editor/constants/color.dart';
import 'package:sfs_editor/core/ads/ads_loader.dart';
import 'package:sfs_editor/core/helper/snapchat_helper.dart';
import 'package:sfs_editor/core/in_app_purchase.dart';
import 'package:sfs_editor/screens/result_screen.dart';
import 'package:sfs_editor/screens/video_editing_screens/show_options_screen.dart';
import 'package:sfs_editor/services/dark_mode_service.dart';
import 'package:sfs_editor/services/getimg_services.dart';
import 'package:share_plus/share_plus.dart';

class EditOptionScreen extends StatefulWidget {
  const EditOptionScreen({super.key});

  @override
  State<EditOptionScreen> createState() => _EditOptionScreenState();
}

class _EditOptionScreenState extends State<EditOptionScreen> {
  Future<void> sendEmail() async {
    final Email email = Email(
        body: '',
        subject: 'Contact Support',
        recipients: ['Support@livroll.com'],
        isHTML: false);
    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? darkMoodColor : Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 14.h,
          ),
          Row(
            children: [
              SizedBox(
                width: 15.w,
              ),
              Text(
                'Edit and share',
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.sp,
                    color: Colors.amber),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 17.w,
              ),
              Expanded(
                  child: Text(
                'Upload an image or video, apply edits, and share your creations',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp),
              )),
              SizedBox(
                width: 17.w,
              )
            ],
          ),
          SizedBox(
            height: 85.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  Uint8List imageData;
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    imageData = await image.readAsBytes();
                    var editedImage = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageEditor(
                          image: imageData,
                        ),
                      ),
                    );
                    await AdsLoader.showInterstitialAd();
                    if (editedImage != null) {
                      Provider.of<GetIMageServices>(context, listen: false)
                          .isInappropriate = false;
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            await SnapChatHelper
                                                .sendImageToSnapChat(
                                                    editedImage!, context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 10),
                                            backgroundColor: Colors.black,
                                            foregroundColor:
                                                const Color.fromARGB(
                                                    255, 216, 213, 213),
                                          ),
                                          child: const Text(
                                            'share to Snap',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20,
                                            ),
                                          )),
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          if (editedImage != null) {
                                            final temp =
                                                await getTemporaryDirectory();
                                            final path =
                                                '${temp.path}/image.jpg';
                                            File(path)
                                                .writeAsBytesSync(editedImage!);
                                            XFile file = XFile(path);
                                            Share.shareXFiles([file]);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 10),
                                          backgroundColor: const Color.fromARGB(
                                              255, 216, 213, 213),
                                          foregroundColor: Colors.black,
                                        ),
                                        child: const Text(
                                          'other apps',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20,
                                          ),
                                        )),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                            onPressed: sendEmail,
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 10),
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 216, 213, 213),
                                              foregroundColor: Colors.black,
                                            ),
                                            child: const Text(
                                              'Report a problem',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20,
                                              ),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("No image"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                child: Container(
                  width: 160.w,
                  height: 145.h,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: themeProvider.isDarkMode
                        ? darkModeHeavey
                        : Colors.white,
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/starryImages/2.png',
                          width: 100.w,
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                        Text(
                          "Edit Image",
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.amber),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              InkWell(
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.video,
                    allowCompression: false,
                  );
                  if (result != null) {
                    final file = File(result.files.single.path!);
                    if (!mounted) return;
                    Provider.of<GetIMageServices>(context, listen: false)
                        .isInappropriate = false;
                    var editedVideo = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ShowOptionsScreen(
                          file: file,
                        ),
                      ),
                    );
                    await AdsLoader.showInterstitialAd();
                    if (editedVideo != null) {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            await SnapChatHelper
                                                .sendVideoToSnapChat(
                                                    editedVideo!, context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 10),
                                            backgroundColor: Colors.black,
                                            foregroundColor:
                                                const Color.fromARGB(
                                                    255, 216, 213, 213),
                                          ),
                                          child: const Text(
                                            'share to Snap',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20,
                                            ),
                                          )),
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          if (editedVideo != null) {
                                            XFile file =
                                                XFile(editedVideo!.path);
                                            Share.shareXFiles([file]);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 10),
                                          backgroundColor: const Color.fromARGB(
                                              255, 216, 213, 213),
                                          foregroundColor: Colors.black,
                                        ),
                                        child: const Text(
                                          'other apps',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20,
                                          ),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: 160.w,
                  height: 145.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: themeProvider.isDarkMode
                        ? darkModeHeavey
                        : Colors.white,
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/starryImages/1.png",
                          width: 100.w,
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                        Text(
                          "Edit Video",
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.amber),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: AdsLoader.adBaner!.size.width.toDouble(),
                height: AdsLoader.adBaner!.size.height.toDouble(),
                child: AdWidget(ad: AdsLoader.adBaner!),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
