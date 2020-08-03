import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as paths;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:flutter/material.dart';

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;
  final picker = ImagePicker();

  Future<void> _takePicture() async {
    final imageFile = await picker.getImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if(imageFile == null) {
      return;
    }
    final File fileImage = File(imageFile.path);
    setState(() {
      _storedImage = fileImage;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = paths.basename(fileImage.path);
    final savedImage = await fileImage.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 120,
          width: 150,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Preview',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(width: 10),
        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text('Take Picture'),
            textColor: Theme.of(context).primaryColor,
            onPressed: _takePicture,
          ),
        ),
      ],
    );
  }
}
