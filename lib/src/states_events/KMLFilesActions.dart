import 'package:equatable/equatable.dart';
import 'package:lg_controller/src/models/KMLData.dart';

/// Bloc events for loading module data.
abstract class KMLFilesEvent extends Equatable {}

/// Event to get module data.
class GET_FILES extends KMLFilesEvent {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

/// Bloc states for loading module data.
abstract class KMLFilesState extends Equatable {}

/// Initial state.
class UninitializedState extends KMLFilesState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

/// State when error has occured.
class ErrorState extends KMLFilesState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

/// State for loading data in background.
class LoadingState extends KMLFilesState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

/// State of completion of retrieving data.
class LoadedState extends KMLFilesState {
  /// Map of all the module data sorted according to categories.
  Map<String, List<KMLData>> data;

  LoadedState(this.data);

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
