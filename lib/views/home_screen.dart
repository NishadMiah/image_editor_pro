import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_editor_pro/controllers/home_controller.dart';
import 'package:image_editor_pro/utils/app_colors.dart';
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
        title: Text(
          'Background Remover',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
          ),
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
              SizedBox(height: 20.h),
              // Main Image Area
              Expanded(
                child: Center(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return _buildLoadingState();
                    }

                    if (controller.processedImage.value != null) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: _buildImageContainer(
                          key: const ValueKey('processed'),
                          child: Image.memory(
                            controller.processedImage.value!,
                            fit: BoxFit.contain,
                          ),
                          label: "Processed Image",
                        ),
                      );
                    }

                    if (controller.originalImage.value != null) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _buildImageContainer(
                          key: const ValueKey('original'),
                          child: Image.file(
                            controller.originalImage.value!,
                            fit: BoxFit.contain,
                          ),
                          label: "Original Image",
                        ),
                      );
                    }

                    return _buildEmptyState();
                  }),
                ),
              ),

              SizedBox(height: 30.h),

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
                    Text(
                      "Choose an action",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          icon: Icons.image_outlined,
                          label: "Gallery",
                          onTap: () =>
                              controller.pickImage(ImageSource.gallery),
                        ),
                        _buildActionButton(
                          icon: Icons.camera_alt_outlined,
                          label: "Camera",
                          onTap: () => controller.pickImage(ImageSource.camera),
                          isPrimary: true,
                        ),
                        Obx(
                          () => _buildActionButton(
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

  Widget _buildLoadingState() {
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
              SizedBox(height: 30.h),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [AppColors.primary, AppColors.accent],
                ).createShader(bounds),
                child: Text(
                  "Removing Background...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Using AI Magic ✨",
                style: TextStyle(color: Colors.white38, fontSize: 12.sp),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageContainer({
    required Widget child,
    required String label,
    Key? key,
  }) {
    return Container(
      key: key,
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
            child: _buildCheckerboard(),
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
              child: Text(
                label,
                style: TextStyle(color: Colors.white, fontSize: 12.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
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
                SizedBox(height: 20.h),
                Text(
                  "No Image Selected",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Pick an image to remove background",
                  style: TextStyle(color: Colors.white38, fontSize: 14.sp),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckerboard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: CheckerboardPainter(),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    bool isPrimary = false,
    bool isEnabled = true,
  }) {
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
                SizedBox(height: 8.h),
                Text(
                  label,
                  style: TextStyle(
                    color: isEnabled ? Colors.white70 : Colors.white30,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CheckerboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.grey.withOpacity(0.1);
    double squareSize = 20;

    for (double i = 0; i < size.width; i += squareSize) {
      for (double j = 0; j < size.height; j += squareSize) {
        if ((i / squareSize).floor() % 2 == (j / squareSize).floor() % 2) {
          canvas.drawRect(Rect.fromLTWH(i, j, squareSize, squareSize), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
