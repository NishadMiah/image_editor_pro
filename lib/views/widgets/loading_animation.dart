import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_editor_pro/core/components/custom_text.dart';
import 'package:image_editor_pro/utils/app_colors.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Outer rotating circle
                  Transform.rotate(
                    angle: value * 6.28 * 2, // 2 full rotations
                    child: Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                  // Inner pulsing circle
                  Transform.scale(
                    scale: 0.5 + (value * 0.3),
                    child: Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [AppColors.accent, AppColors.primary],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Gap(30.h),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                ).createShader(bounds),
                child: CustomText(
                  text: "Removing Background...",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Gap(10.h),
              CustomText(
                text: "Using AI Magic ✨",
                fontSize: 12.sp,
                color: Colors.white38,
              ),
            ],
          ),
        );
      },
    );
  }
}
