import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/bottle_repository.dart';
import 'collection_event.dart';
import 'collection_state.dart';

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  final BottleRepository bottleRepository;

  CollectionBloc({required this.bottleRepository})
    : super(CollectionInitial()) {
    on<LoadCollectionEvent>(_onLoadCollection);
    on<RefreshCollectionEvent>(_onRefreshCollection);
  }

  Future<void> _onLoadCollection(
    LoadCollectionEvent event,
    Emitter<CollectionState> emit,
  ) async {
    emit(CollectionLoading());
    try {
      final bottles = await bottleRepository.getBottles();
      emit(CollectionLoaded(bottles));
    } catch (e) {
      emit(CollectionError('Failed to load collection: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshCollection(
    RefreshCollectionEvent event,
    Emitter<CollectionState> emit,
  ) async {
    try {
      final bottles = await bottleRepository.getBottles();
      emit(CollectionLoaded(bottles));
    } catch (e) {
      emit(CollectionError('Failed to refresh collection: ${e.toString()}'));
    }
  }
}
