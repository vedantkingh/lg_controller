import 'dart:convert';

import 'package:lg_controller/src/models/OverlayItem.dart';
import 'package:lg_controller/src/models/PointData.dart';

/// Placemark data model class.
class PlacemarkData extends OverlayItem {
  /// Coordinates of the point.
  PointData point;

  /// Size of placemark icon.
  int iconSize = 3;

  /// Color of placemark icon.
  int iconColor = 0;

  PlacemarkData(this.point, id, title, desc)
      : super(id: id, title: title, desc: desc);

  /// Convert [PlacemarkData] instance to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': 'Placemark',
      'title': title,
      'desc': desc,
      'iconSize': iconSize,
      'iconColor': iconColor,
      'point': point,
    };
  }

  /// Create [PlacemarkData] instance from JSON map.
  PlacemarkData.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.point = PointData.fromJson(json['point']);
    this.title = json['title'];
    this.desc = json['desc'];
    this.iconSize = json['iconSize'];
    this.iconColor = json['iconColor'];
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
