import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Take Photo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: TakePhotoScreen(),
    );
  }
}

class TakePhotoScreen extends StatefulWidget {
  @override
  _TakePhotoScreenState createState() => _TakePhotoScreenState();
}

class _TakePhotoScreenState extends State<TakePhotoScreen> {
  File? _imageFile;
  final FlutterTts flutterTts = FlutterTts();

  // Function to open the camera and capture a photo
  Future<void> _takePhoto() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (image != null) {
        _imageFile = File(image.path);
      }
    });

    // Send the image to the API if it's not null
    if (_imageFile != null) {
      await _sendImageToAPI(_imageFile!);
    }
  }

  // Function to send image to the API
Future<void> _sendImageToAPI(File imageFile) async {
  try {
    // Send the request with image file
    var uri = Uri.parse('http://44.204.66.45/generate_image_description/');
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
      await _speakDescription(description);
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


  // Function to speak description
  Future<void> _speakDescription(String description) async {
    await flutterTts.speak(description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Photo'),
      ),
      body: Center(
        child: _imageFile == null
            ? Text('No image selected.')
            : Image.file(_imageFile!),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          margin: EdgeInsets.only(bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                onPressed: () {
                  // Add functionality for call button
                  print('Call button pressed'); 
                },
                tooltip: 'Call',
                child: Icon(Icons.phone),
              ),
              FloatingActionButton(
                onPressed: _takePhoto,
                tooltip: 'Take Photo',
                child: Icon(Icons.camera),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
