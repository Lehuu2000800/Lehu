import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class UploadForm extends StatefulWidget {
  @override
  _UploadFormState createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  String? _filePath;
  FileType _fileType = FileType.any;
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _category;
  String? _description;
  List<String> _categories = ['Image', 'Video', 'Audio'];

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: _fileType,
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    }
  }

  Future<void> _uploadData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://unpasset.testweb.skom.id/api/user/store'),
      );

      request.fields['title'] = _title!;
      request.fields['category'] = _category!;
      request.fields['description'] = _description!;

      if (_filePath != null) {
        File file = File(_filePath!);
        String fileName = file.path.split('/').last;
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          _filePath!,
          filename: fileName,
        ));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        // Upload success
        print('Upload success');
      } else {
        // Upload failed
        print('Upload failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Color.fromRGBO(212, 129, 102, 1),
        title: Text('Upload Form'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_filePath != null) ...[
                  Text('Selected file: $_filePath'),
                  SizedBox(height: 20.0),
                ],
                ElevatedButton(
                   style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(212, 129, 102, 1),
                          ),
                        ),
                  onPressed: () {
                    _pickFile();
                  },
                  child: Text('Choose File'),
                ),
                SizedBox(height: 20.0),
                DropdownButton<String>(
                  value: _category,
                  onChanged: (value) {
                    setState(() {
                      _category = value!;
                    });
                  },
                  hint: Text('Category'),
                  items: _categories.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value;
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                   style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(212, 129, 102, 1),
                          ),
                        ),
                  onPressed: () {
                    _uploadData();
                  },
                  child: Text('Upload'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}