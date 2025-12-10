import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_editor_pro/core/components/custom_text.dart';
import 'package:image_editor_pro/utils/app_colors.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(30.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 80.sp,
                    color: AppColors.primary.withOpacity(0.5),
                  ),
                ),
                Gap(20.h),
                CustomText(
                  text: "No Image Selected",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
                Gap(10.h),
                CustomText(
                  text: "Pick an image to remove background",
                  fontSize: 14.sp,
                  color: Colors.white38,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
