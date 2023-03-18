import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lg_controller/src/menu/OverlayMenu.dart';
import 'package:lg_controller/src/models/OverlayItem.dart';

/// Bloc events for handling tap gestures.
abstract class PointEvent extends Equatable {}

/// Event for registering tap gesture.
class TAP_EVENT extends PointEvent {
  /// Coordinates of tap gesture.
  LatLng point;

  /// Currently selected overlay tool.
  OverlayMenu menu;

  TAP_EVENT(this.point, this.menu);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

/// Event for clearing tap gesture.
class CLEAR_EVENT extends PointEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

/// Event for clearing tap gesture.
class MODIFY_EVENT extends PointEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

/// Bloc states for handling tap gestures.
abstract class PointState extends Equatable {}

/// Initial state.
class UninitializedState extends PointState {
  /// Data of the previous overlay features.
  List<OverlayItem> data;

  UninitializedState(this.data);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

/// State when error has occured.
class ErrorState extends PointState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

/// State for processing data in background.
class ProcessingState extends PointState {
  /// Data of the overlay feature.
  OverlayItem data;

  ProcessingState(this.data);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

/// State of completion of drawing overlay feature.
class CompletedState extends PointState {
  CompletedState();

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
