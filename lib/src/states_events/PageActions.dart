import 'package:equatable/equatable.dart';
import 'package:lg_controller/src/models/KMLData.dart';

/// Bloc events for page transitions.
abstract class PageEvent extends Equatable {}

/// Home event.
class HOME extends PageEvent {
  /// Data of currently running module.
  KMLData data;

  HOME(this.data);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

/// To clear data on home event.
class CLEARDATA extends PageEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

/// POI page event.
class POI extends PageEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

/// Guide page event.
class GUIDE extends PageEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

/// Overlay page event.
class OVERLAY extends PageEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

/// Profile page event.
class PROFILE extends PageEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

/// Settings page event.
class SETTINGS extends PageEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

/// Tour page event.
class TOUR extends PageEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

/// Bloc states for page transitions.
abstract class PageState {}

/// Home page state.
class HomeState extends PageState {
  /// Data of currently running module.
  KMLData data;

  HomeState(this.data);
}

/// POI page state.
class POIState extends PageState {}

/// Guide page state.
class GuideState extends PageState {}

/// Overlay page state.
class OverState extends PageState {}

/// Profile page state.
class ProfileState extends PageState {}

/// Settings page state.
class SettingsState extends PageState {}

/// Tour page state.
class TourState extends PageState {}

/// Tutorial page state.
class TutorialState extends PageState {}
