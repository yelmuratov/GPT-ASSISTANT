import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Take Photo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: TakePhotoScreen(cameras: cameras),
    );
  }
}

class TakePhotoScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const TakePhotoScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  _TakePhotoScreenState createState() => _TakePhotoScreenState();
}

class _TakePhotoScreenState extends State<TakePhotoScreen> {
  late CameraController _cameraController;
  File? _imageFile;
  final FlutterTts flutterTts = FlutterTts();
  final ImagePicker _picker = ImagePicker();
  bool _isCameraReady = false;
  bool _isSendingImage = false;
  String _selectedLanguage = 'en'; // Default selected language is English

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameraController = CameraController(
      widget.cameras.first,
      ResolutionPreset.medium,
    );
    await _cameraController.initialize();
    setState(() {
      _isCameraReady = true;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    try {
      setState(() {
        _isSendingImage = true; // Start sending image
      });
      final XFile image = await _cameraController.takePicture();
      setState(() {
        _isSendingImage = false; // Finished sending image
        if (image != null) {
          _imageFile = File(image.path);
        }
      });

      // Send the image to the API if it's not null
      if (_imageFile != null) {
        await _sendImageToAPI(_imageFile!, _selectedLanguage);
      }
    } catch (e) {
      print('Error taking photo: $e');
      setState(() {
        _isSendingImage = false; // Error occurred while sending image
      });
    }
  }

  Future<void> _sendImageToAPI(File imageFile, String lang) async {
    try {
      var uri = Uri.parse('http://44.204.66.45/generate_image_description/?lang=$lang');
      var request = http.MultipartRequest('POST', uri);

      // Attach the image file to the request
      var fileStream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();
      var multipartFile = http.MultipartFile(
        'file',
        fileStream,
        length,
        filename: imageFile.path.split('/').last,
      );
      request.files.add(multipartFile);

      // Send the request
      var response = await request.send();

      // Handle response
      if (response.statusCode == 200) {
        // Successful API call
        final description = await response.stream.bytesToString();
        print('Image successfully sent to API.');
        print('API Response: $description');

        // Speak the description
        await _speakDescription(description, lang);
      } else {
        // Error in API call
        print('Failed to send image to API. Status code: ${response.statusCode}');
        final errorResponse = await response.stream.bytesToString();
        print('Error response: $errorResponse');
      }
    } catch (e) {
      // Catch any exceptions
      print('Error: $e');
    }
  }

  Future<void> _speakDescription(String description, String lang) async {
    try {
      // Set language for TTS
      await flutterTts.setLanguage(lang);

      // Speak the description
      await flutterTts.speak(description);
    } catch (e) {
      print('Error in TTS: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final navigationBarHeight = screenHeight * 0.30; // 30% of screen height
    final bodyHeight = screenHeight * 0.70; // 70% of screen height

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        bottomOpacity: 0,
        elevation: 0,
        actions: [
          _buildLanguageAction('EN', 'en'),
          SizedBox(width: 20),
          _buildLanguageAction('RU', 'ru'),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              height: bodyHeight,
              child: Center(
                child: _isCameraReady
                    ? CameraPreview(_cameraController)
                    : CircularProgressIndicator(),
              ),
            ),
          ),
          Container(
            height: navigationBarHeight,
            color: Colors.blueGrey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  color: Colors.blue,
                  width: MediaQuery.of(context).size.width / 2,
                  height: double.infinity,
                  child: IconButton(
                    onPressed: () {
                      print('Call button pressed');
                    },
                    icon: Icon(Icons.phone, size: 50),
                    color: Colors.white,
                  ),
                ),
                Container(
                  color: _isCameraReady && !_isSendingImage ? Colors.red : Colors.grey,
                  width: MediaQuery.of(context).size.width / 2,
                  height: double.infinity,
                  child: IconButton(
                    onPressed: _isCameraReady && !_isSendingImage ? _takePhoto : null,
                    icon: Icon(Icons.camera, size: 50),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageAction(String label, String langCode) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLanguage = langCode;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: _selectedLanguage == langCode ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
