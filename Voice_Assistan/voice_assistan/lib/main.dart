import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<String> sendFileToAPI(String filePath) async {
  String apiUrl = 'https://vocalview.diyarbek.ru/docs'; // API endpoint

  try {
    // Read the file as bytes
    List<int> fileBytes = await File(filePath).readAsBytes();

    // Send the file bytes to the API
    var response = await http.post(
      Uri.parse(apiUrl),
      body: fileBytes,
      headers: {
        HttpHeaders.contentTypeHeader:
            'application/octet-stream', // Content type for binary data
      },
    );

    if (response.statusCode == 200) {
      print('File uploaded successfully');
      print('Response: ${response.body}');
      return 'File uploaded successfully'; // Return success message
    } else {
      throw 'Failed to upload file. Status code: ${response.statusCode}'; // Throw error
    }
  } catch (e) {
    throw 'Error sending request: $e'; // Throw error
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(CameraApp(camera: firstCamera));
}

class CameraApp extends StatefulWidget {
  final CameraDescription camera;

  const CameraApp({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Camera App'),
        ),
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_controller);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              await _initializeControllerFuture;
              final image = await _controller.takePicture();

              print(sendFileToAPI(image as String));
              // Save the taken picture to a temporary directory
              final path = join(
                (await getTemporaryDirectory()).path,
                '${DateTime.now()}.png',
              );
              await image.saveTo(path);
              // Display the image
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(imagePath: path),
                ),
              );
            } catch (e) {
              print(e);
            }
          },
          child: Icon(Icons.camera),
        ),
      ),
    );
  }

  join(path, String s) {}

  getTemporaryDirectory() {}
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Captured Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}
