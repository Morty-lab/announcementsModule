import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class AnnouncementForm extends StatefulWidget {
  @override
  _AnnouncementFormState createState() => _AnnouncementFormState();
}

class _AnnouncementFormState extends State<AnnouncementForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _authorController = TextEditingController(); // New controller for the Author field
  DateTime _timestamp = DateTime.now();
  String _author = '';
  File _image = new File("assets/default_announcment.jpg");
  String? _imageUrl;
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile!= null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

   Future<void> _submitForm() async {
    try {
      if (_image!= null) {
        // Upload the image to Firebase Storage
        Reference ref = FirebaseStorage.instance.ref().child('announcements/${_image!.path.split('/').last}');
        await ref.putFile(_image);
        _imageUrl = await ref.getDownloadURL(); // Get the download URL after uploading
      } else {
        _imageUrl = ''; // Set a default value if no image is selected
      }

      // Save the announcement to Firestore
      await FirebaseFirestore.instance.collection('announcements').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'author': _authorController.text,
        'image': _imageUrl?? '', // Use the image URL or empty string if no image was uploaded
      });

      // Clear the text fields
      _titleController.clear();
      _descriptionController.clear();
      _authorController.clear();

      // Optionally, show a success message
    } catch (e) {
      print(e); // Log the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Announcement Form')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              Container(
                width: 300,
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Announcement Title',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 50,),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image',),
              ),
              SizedBox(height: 20,),
              if (_image!= null)
                Image.file(_image, width: 100, height: 100),
              Container(
                width: 300,
                child: TextField(
                  controller: _authorController, // Use the new controller here
                  decoration: InputDecoration(
                    labelText: 'Author',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
