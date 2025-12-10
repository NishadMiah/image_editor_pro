import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:local_rembg/local_rembg.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var originalImage = Rxn<File>();
  var processedImage = Rxn<Uint8List>();
  var isInitialized = false.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    requestPermissions();
    initializeBackgroundRemover();
  }

  Future<void> initializeBackgroundRemover() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      isInitialized.value = true;
    } catch (e) {
      isInitialized.value = true;
    }
  }

  Future<void> requestPermissions() async {
    await [Permission.storage, Permission.camera, Permission.photos].request();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        originalImage.value = File(pickedFile.path);
        processedImage.value = null;
        await removeBackground(originalImage.value!);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> removeBackground(File file) async {
    if (!isInitialized.value) {
      Get.snackbar(
        'Not Ready',
        'Please wait a moment...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      LocalRembgResultModel result = await LocalRembg.removeBackground(
        imagePath: file.path,
        cropTheImage: false,
      );

      if (result.status == 1 && result.imageBytes != null) {
        processedImage.value = Uint8List.fromList(result.imageBytes!);

        Get.snackbar(
          '✅ Success!',
          'Background removed successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      } else {
        throw Exception(result.errorMessage ?? 'Failed to process image');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to remove background: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveImage() async {
    if (processedImage.value == null) return;
    try {
      Directory directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = Directory('/storage/emulated/0/Downloads');
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final fileName =
          'removed_bg_${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      await file.writeAsBytes(processedImage.value!);

      Get.snackbar(
        '💾 Saved to Downloads!',
        'Image saved successfully\n$fileName',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
}
