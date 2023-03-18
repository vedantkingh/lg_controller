import 'package:lg_controller/src/models/OverlayItem.dart';
import 'package:lg_controller/src/models/PointData.dart';

/// Image data model class.
class ImageData extends OverlayItem {
  /// Coordinates of the point.
  PointData point;

  /// Color of placemark icon.
  List<int> image;

  List<int> thumbnail;

  ImageData(this.point, id, title, desc, this.image, this.thumbnail)
      : super(id: id, title: title, desc: desc);

  /// Convert [ImageData] instance to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': 'Image',
      'point': point,
      'title': title,
      'desc': desc,
      'image': null,
      'thumbnail': null,
    };
  }

  /// Create [ImageData] instance from JSON map.
  ImageData.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.point = PointData.fromJson(json['point']);
    this.title = json['title'];
    this.desc = json['desc'];
    this.image = null;
    this.thumbnail = null;
  }

  /// Give JSON map as string in toString override.
  @override
  String toString() {
    return toJson().toString();
  }

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
