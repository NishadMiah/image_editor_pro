import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_editor_pro/core/utils/app_colors.dart';
import 'package:image_editor_pro/core/utils/app_sizes.dart';
import 'package:image_editor_pro/core/utils/icon_path.dart';
import 'package:image_editor_pro/core/components/custom_image.dart';
import 'package:image_editor_pro/core/components/custom_text.dart';

class CustomBackButton extends StatelessWidget implements PreferredSizeWidget {
  const CustomBackButton({
    super.key,
    this.titleName,
    this.color,
    this.isBack = true,
  });
  final String? titleName;
  final Color? color;
  final bool isBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: AppSizes.padding,
      child: Center(
        child: Column(
          children: [
            Gap(50.h),
            Row(
              // mainAxisAlignment: .spaceBetween,
              children: [
                isBack
                    ? Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: AppColors.containerColor,
                          borderRadius: .circular(50.r),
                        ),
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: CustomImage(
                            imageSrc: IconPath.arrowBack,
                            width: 24.w,
                            imageColor: color ?? AppColors.black,
                            height: 24.h,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                Gap(10.w),
                CustomText(
                  text: titleName ?? "",
                  fontSize: 20.w,
                  fontWeight: .w600,
                  textAlign: .center,
                  color: color ?? AppColors.black7,
                  right: 8.w,
                ),
                const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}
