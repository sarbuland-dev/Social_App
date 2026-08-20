import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

/// CloudinaryService: Cloudinary pe image upload karne ka pura logic
/// yahan hai. Firebase Storage ki jagah ab isse use karenge.
class CloudinaryService {
  // 👇 Apna Cloudinary Dashboard se ye 2 cheezein yahan daal do
  static const String cloudName = "ljfrztcn";
  static const String uploadPreset = "social_app_unsigned";

  static String get _uploadUrl =>
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload";

  /// Image bytes (Uint8List) ko Cloudinary pe upload karta hai aur
  /// uploaded image ka public URL return karta hai.
  static Future<String> uploadImage(Uint8List imageBytes) async {
    final uri = Uri.parse(_uploadUrl);

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: 'post_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      );

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(responseData);
      return data['secure_url']; // ye final image URL hai
    } else {
      throw Exception("Cloudinary upload failed: $responseData");
    }
  }
}