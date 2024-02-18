import 'package:flutter/material.dart';
import 'package:mynotes/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:mynotes/utils/constants/sizes.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: kbsAppSizes.defaultSpace,
      bottom: 80,
      child: ElevatedButton(
        onPressed: () => OnBoardingController().nextPage(context),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: const Color(0xFF33cccc), // Remove the comma after the color value
          minimumSize: const Size(60, 60),
        ),
        child: const Icon(Icons.arrow_right, color: Colors.white, size: 35),
      ),
    );
  }
}
