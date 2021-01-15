import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class ImageInput extends StatefulWidget {
  ImageInput({Key key, this.onImageSelect}) : super(key: key);
  final Function onImageSelect;
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;
  Future<void> _takePicture() async {
    final imgpicker = ImagePicker();
    final imageFile =
        await imgpicker.getImage(source: ImageSource.gallery, maxWidth: 600);

    if (imageFile == null) {
      return;
    }
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(appDir.path);

    final savedImage =
        await File(imageFile.path).copy('${appDir.path}/$fileName');
    widget.onImageSelect(savedImage);
    setState(() {
      _storedImage = File(imageFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.blueGrey),
          ),
          child: _storedImage == null
              ? Text("NO IMAGE TAKEN")
              : Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton.icon(
              onPressed: _takePicture,
              icon: Icon(Icons.camera),
              label: Text(
                "take picture",
                textAlign: TextAlign.justify,
              )),
        )
      ],
    );
  }
}
