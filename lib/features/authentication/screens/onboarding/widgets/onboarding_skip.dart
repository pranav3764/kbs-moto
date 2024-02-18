import 'package:mynotes/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/utils/constants/sizes.dart';
class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 70,
      right: kbsAppSizes.defaultSpace,
      child: TextButton(
        onPressed: () {
          // Instantiate OnBoardingController and call its skipPage method
          OnBoardingController().skipPage();
        },
        child: const Text("Skip"),
      ),
    );
  }
}
