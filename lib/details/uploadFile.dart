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
      if (_file == null) {
        // Handling jika file belum dipilih
        throw Exception("File belum dipilih");
      }

      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] =
            "Bearer 39|RQ134vEGFSUV7Km4je8F65sfjpCPaUTWh1UchECd"
        ..fields['title'] = _titleController.text
        ..fields['body'] = _bodyController.text
        ..fields['category_id'] = _categoryController.text
        ..files.add(await http.MultipartFile.fromPath('file', _file!.path));

      final response = await request.send();

      if (response.statusCode == 201) {
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
