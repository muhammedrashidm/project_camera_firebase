import 'package:flutter/cupertino.dart';
import 'package:job_test/models/image_modal.dart';

class ImageListProvider extends ChangeNotifier{

 List<ImageModal> _images=[];
 List<ImageModal> get images=>_images;



 void addImageToList(ImageModal image){
   _images.add(image);
   notifyListeners();
 }

}