import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CloudinaryService {
  static const String cloudName = 'dzah1rpmd';
  static const String apiKey = '235965823296761';
  static const String apiSecret = '5ZUk9GTcHcuGbCgt44HBrHeoCeo';
  static const String uploadPreset = 'digitalRidrProfileImagePreset'; // create this in Cloudinary

  /// Uploads an image and returns the secure URL
  static Future<String?> uploadImage(File imageFile) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    final resStr = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final jsonResp = json.decode(resStr);
      return jsonResp['secure_url'];
    } else {
      debugPrint('MYAPCloudinary upload failed: $resStr');

      return null;
    }
  }

  /// Uploads image to Cloudinary and saves a local copy in app directory
  static Future<String?> uploadAndSaveLocally(File imageFile, String fileName) async {
    try {
      // 1. Upload to Cloudinary
      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      final resString = await response.stream.bytesToString();
      final resJson = json.decode(resString);

      if (response.statusCode == 200) {
        final cloudUrl = resJson['secure_url'];

        // 2. Save locally
        final localPath = await _saveImageLocally(imageFile, fileName);

        debugPrint("MYAPP : uploadAndSaveLocally -> Image uploaded: $cloudUrl, saved locally at: $localPath");
        return cloudUrl;
      } else {
        debugPrint("MYAPP : uploadAndSaveLocally -> Cloudinary upload failed: $resString");
        return null;
      }
    } catch (e) {
      debugPrint("MYAPP : uploadAndSaveLocally -> Error uploading to Cloudinary: $e");
      return null;
    }
  }

  /// Downloads an image from a URL and saves to app directory
  static Future<String?> downloadAndSaveLocally(String url, String fileName) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);
        debugPrint("Image downloaded and saved locally at: ${file.path}");
        return file.path;
      } else {
        debugPrint("MYAPP : downloadAndSaveLocally -> Failed to download image from $url");
        return null;
      }
    } catch (e) {
      debugPrint("MYAPP : downloadAndSaveLocally -> Error downloading image: $e");
      return null;
    }
  }

  /// Helper function to save a File locally
  static Future<String> _saveImageLocally(File imageFile, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final localFile = File('${directory.path}/$fileName');
    await imageFile.copy(localFile.path);
    debugPrint("MYAPP : _saveImageLocally -> Saved locally to: ${localFile.path}");
    return localFile.path;
  }

  static Future<String?> fetchProfileImage(String imageUrl, String userId) async {
    // Downloads Cloudinary image and saves locally
    String? localPath = await downloadAndSaveLocally(
        imageUrl, '$userId.jpg');
    return localPath;

  }

  static Future<String?> fetchProfileImageFilePath(String profileUrl, String userId) async {
    // Fetches the profile image from the user id
    String fileName = '$userId.jpg';
    late final File file;
    try{
      final directory = await getApplicationDocumentsDirectory();
      file = File('${directory.path}/$fileName');
      return file.path;
    } catch(e) {
      debugPrint("MYAPP : fetchProfileImageFile -> Image not found locally in : ${file.path}, downloading it again ");
      return downloadAndSaveLocally(profileUrl, fileName).toString();
    }
  }

}
