// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mynotes/auth/login_page.dart';
//
// class OnBoardingController extends GetxController{
//   static OnBoardingController get instance => Get.find();
//
//   /// Variables
//   final pageController = PageController();
//   Rx<int> currentPageIndex = 0.obs;
//
//   /// Update Current Index when Page Scroll
//   void updatePageIndicator(int index) {
//     currentPageIndex.value = index;
//   }
//
//   // jump to the specific dot selected page
//   void dotNavigationClick(index) {
//     currentPageIndex.value = index;
//     pageController.jumpTo(index);
//   }
//
//   // update current index and jump to next page
//   void nextPage() {
//     if(currentPageIndex.value == 2) {
//       Get.to('/login');
//     } else {
//       int page = currentPageIndex.value + 1;
//       pageController.jumpToPage(page);
//     }
//   }
//
//   // Update Current index and jump to the last page
//   void skipPage() {
//     currentPageIndex.value = 2;
//     pageController.jumpToPage(2);
//   }
// }

import 'package:flutter/material.dart';
import 'package:mynotes/auth/login_page.dart';

class OnBoardingController {
  static final OnBoardingController _instance = OnBoardingController._internal();

  factory OnBoardingController() {
    return _instance;
  }

  OnBoardingController._internal();

  /// Variables
  final pageController = PageController();
  ValueNotifier<int> currentPageIndex = ValueNotifier<int>(0);

  /// Update Current Index when Page Scroll
  void updatePageIndicator(int index) {
    currentPageIndex.value = index;
  }

  // jump to the specific dot selected page
  void dotNavigationClick(int index) {
    currentPageIndex.value = index;
    pageController.jumpTo(index.toDouble());
  }

  // update current index and jump to next page
  void nextPage(BuildContext context) {
    if (currentPageIndex.value == 2) {
      Navigator.of(context).pushNamed('/login');
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  // Update Current index and jump to the last page
  void skipPage() {
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }
}
