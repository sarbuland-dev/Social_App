import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;


class CloudinaryService {

  static const String cloudName = "ljfrztcn";
  static const String uploadPreset = "social_app_unsigned";

  static String get _uploadUrl =>
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload";

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
      return data['secure_url'];
    } else {
      throw Exception("Cloudinary upload failed: $responseData");
    }
  }
}