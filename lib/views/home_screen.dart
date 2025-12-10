import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_editor_pro/views/controllers/home_controller.dart';
import 'package:image_editor_pro/core/components/custom_text.dart';
import 'package:image_editor_pro/utils/app_colors.dart';
import 'package:image_editor_pro/views/widgets/circular_action_button.dart';
import 'package:image_editor_pro/views/widgets/empty_state.dart';
import 'package:image_editor_pro/views/widgets/image_display_container.dart';
import 'package:image_editor_pro/views/widgets/loading_animation.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: CustomText(
          text: 'Background Remover',
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, Colors.black],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Gap(20.h),
              // Main Image Area
              Expanded(
                child: Center(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const LoadingAnimation();
                    }

                    if (controller.processedImage.value != null) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: ImageDisplayContainer(
                          key: const ValueKey('processed'),
                          label: "Processed Image",
                          child: Image.memory(
                            controller.processedImage.value!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    }

                    if (controller.originalImage.value != null) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: ImageDisplayContainer(
                          key: const ValueKey('original'),
                          label: "Original Image",
                          child: Image.file(
                            controller.originalImage.value!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    }

                    return const EmptyState();
                  }),
                ),
              ),

              Gap(30.h),

              // Controls
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CustomText(
                      text: "Choose an action",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                    Gap(20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircularActionButton(
                          icon: Icons.image_outlined,
                          label: "Gallery",
                          onTap: () =>
                              controller.pickImage(ImageSource.gallery),
                        ),
                        CircularActionButton(
                          icon: Icons.camera_alt_outlined,
                          label: "Camera",
                          onTap: () => controller.pickImage(ImageSource.camera),
                          isPrimary: true,
                        ),
                        Obx(
                          () => CircularActionButton(
                            icon: Icons.save_alt,
                            label: "Save",
                            onTap: controller.processedImage.value != null
                                ? () => controller.saveImage()
                                : null,
                            isEnabled: controller.processedImage.value != null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
