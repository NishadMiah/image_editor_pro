import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_editor_pro/core/components/custom_text.dart';
import 'package:image_editor_pro/utils/app_colors.dart';
import 'package:image_editor_pro/views/widgets/checkerboard_painter.dart';

class ImageDisplayContainer extends StatelessWidget {
  final Widget child;
  final String label;

  const ImageDisplayContainer({
    super.key,
    required this.child,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.9.sw,
      height: 0.5.sh,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
      ),
      child: Stack(
        children: [
          // Checkerboard background for transparency
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: CheckerboardPainter(),
                );
              },
            ),
          ),
          Center(child: child),
          Positioned(
            top: 10,
            left: 10,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: CustomText(
                text: label,
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
