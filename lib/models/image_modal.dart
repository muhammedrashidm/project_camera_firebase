import 'dart:convert';

ImageModal imageModalFromJson(String str) => ImageModal.fromJson(json.decode(str));

String imageModalToJson(ImageModal data) => json.encode(data.toJson());

class ImageModal {
  ImageModal({
    required this.imageSrc,
  });

  String imageSrc;

  factory ImageModal.fromJson(Map<String, dynamic> json) => ImageModal(
    imageSrc: json["image_src"],
  );

  Map<String, dynamic> toJson() => {
    "image_src": imageSrc,
  };
}
