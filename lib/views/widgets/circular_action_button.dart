import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_editor_pro/core/components/custom_text.dart';
import 'package:image_editor_pro/utils/app_colors.dart';

class CircularActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isPrimary;
  final bool isEnabled;

  const CircularActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.isPrimary = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isEnabled
        ? (isPrimary ? AppColors.accent : Colors.white)
        : Colors.grey;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(milliseconds: 400 + (isPrimary ? 100 : 0)),
        builder: (context, double value, child) {
          return Transform.scale(
            scale: value,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: isPrimary
                        ? AppColors.primary.withOpacity(0.2)
                        : Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isPrimary ? AppColors.primary : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: isPrimary && isEnabled
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(icon, color: color, size: 28.sp),
                ),
                Gap(8.h),
                CustomText(
                  text: label,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: isEnabled ? Colors.white70 : Colors.white30,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
