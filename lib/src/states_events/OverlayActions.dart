import 'package:equatable/equatable.dart';
import 'package:lg_controller/src/menu/OverlayMenu.dart';
import 'package:lg_controller/src/models/KMLData.dart';

/// Bloc events for handling map events.
abstract class OverlayEvent extends Equatable {}

/// Event to freeze map.
class FREEZE extends OverlayEvent {
  /// Currently selected overlay tool.
  OverlayMenu menu;

  FREEZE(this.menu);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

/// Event to unfreeze map.
class UNFREEZE extends OverlayEvent {
  /// Data of current camera position.
  KMLData data;

  UNFREEZE(this.data);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

/// Bloc states for handling map events.
abstract class OverlaysState extends Equatable {}

/// State for freezed map.
class FrozenState extends OverlaysState {
  /// Currently selected overlay tool.
  OverlayMenu menu;

  FrozenState(this.menu);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

/// Initial state.
class UnfrozenState extends OverlaysState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
