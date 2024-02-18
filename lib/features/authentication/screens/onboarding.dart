import 'dart:async';
import 'package:mynotes/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:mynotes/features/authentication/screens/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:mynotes/features/authentication/screens/onboarding/widgets/onboarding_next_button.dart';
import 'package:mynotes/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:mynotes/features/authentication/screens/onboarding/widgets/onboarding_skip.dart';
import 'package:mynotes/utils/constants/image_strings.dart';
import 'package:mynotes/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged:  controller.updatePageIndicator,
            children: [
              OnBoardingPage(
                  image: kbsAppImages.OnBoardingImage1,
                  title: kbsAppTexts.OnBoardingTitle1,
                  subTitle: kbsAppTexts.OnBoardingSubTitle1
              ),
              OnBoardingPage(
                  image: kbsAppImages.OnBoardingImage2,
                  title: kbsAppTexts.OnBoardingTitle2,
                  subTitle: kbsAppTexts.OnBoardingSubTitle2
              ),
              OnBoardingPage(
                  image: kbsAppImages.OnBoardingImage3,
                  title: kbsAppTexts.OnBoardingTitle3,
                  subTitle: kbsAppTexts.OnBoardingSubTitle3
              ),
            ],
          ),
          const OnBoardingSkip(),
          OnBoardingDotNavigation(),
          OnBoardingNextButton()
        ],
      ),
    );
  }
}



