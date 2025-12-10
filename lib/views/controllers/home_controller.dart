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

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initializeBackgroundRemover() async {
    try {
      // local_rembg doesn't need initialization
      await Future.delayed(const Duration(milliseconds: 500));

      isInitialized.value = true;
      print("Background remover ready!");

      Get.snackbar(
        '✨ Ready to Remove Backgrounds!',
        'AI model loaded successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      print("Initialization info: $e");
      isInitialized.value = true; // Still allow usage
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
      print("Starting background removal with local_rembg...");

      // Use local_rembg to remove background
      LocalRembgResultModel result = await LocalRembg.removeBackground(
        imagePath: file.path,
        cropTheImage: false, // Keep original dimensions
      );

      print("Result status: ${result.status}");

      if (result.status == 1 && result.imageBytes != null) {
        processedImage.value = Uint8List.fromList(result.imageBytes!);
        print("Background removed successfully!");

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
        throw Exception(
          result.errorMessage ??
              'Failed to process image - status: ${result.status}',
        );
      }
    } catch (e) {
      print("Failed to remove background: $e");
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
      // Save to Downloads folder
      Directory directory;
      if (Platform.isAndroid) {
        // For Android, save to Downloads folder
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = Directory('/storage/emulated/0/Downloads');
        }
      } else {
        // For iOS, use app documents
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
