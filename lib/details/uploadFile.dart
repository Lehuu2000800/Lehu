import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class UploadDataScreen extends StatefulWidget {
  const UploadDataScreen({Key? key}) : super(key: key);

  @override
  _UploadDataScreenState createState() => _UploadDataScreenState();
}

class _UploadDataScreenState extends State<UploadDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _categoryController = TextEditingController();
  File? _file;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _uploadData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final url = Uri.parse("http://192.168.202.40:3000/api/user/store");
      try {
        final bytes = await _file!.readAsBytes();
        final base64Image = base64Encode(bytes);
        if (base64Image == null || base64Image.isEmpty) {
          // Handling jika encoding base64 gagal
          throw Exception("Failed to encode file to base64");
        }

        final response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                "Bearer 39|RQ134vEGFSUV7Km4je8F65sfjpCPaUTWh1UchECd",
          },
          body: json.encode({
            'title': _titleController.text,
            'file': base64Image,
            'body': _bodyController.text,
            'category_id': _categoryController.text,
          }),
        );

        if (response.statusCode == 200) {
          // Upload data berhasil
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Data berhasil diupload"),
            duration: Duration(seconds: 2),
          ));
        } else {
          // Upload data gagal
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Upload Gagal"),
              content: Text(
                  "Terjadi kesalahan saat mengupload data. Silakan coba lagi."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        // Tambahkan code untuk menangani kesalahan yang terjadi saat upload data
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Upload Data"),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Title"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Title cannot be empty";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: "Category ID"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Category ID cannot be empty";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final file = await _pickFile();
                      setState(() {
                        _file = file;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(212, 129, 102, 1)),
                    ),
                    child: Text("Select File"),
                  ),
                ),
              ),
              if (_file != null) Text(_file!.path),
              SizedBox(height: 16.0),
              Expanded(
                child: TextFormField(
                  controller: _bodyController,
                  decoration: InputDecoration(labelText: "Body"),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Body cannot be empty";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _uploadData,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(212, 129, 102, 1)),
                ),
                child: Text("Upload Data"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<File?> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return null;
    return File(result.files.single.path!);
  }
}
