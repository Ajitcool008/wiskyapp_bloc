import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/bottle_repository.dart';
import 'bottle_event.dart';
import 'bottle_state.dart';

class BottleBloc extends Bloc<BottleEvent, BottleState> {
  final BottleRepository bottleRepository;

  BottleBloc({required this.bottleRepository}) : super(BottleInitial()) {
    on<LoadBottleEvent>(_onLoadBottle);
    on<LoadTastingNotesEvent>(_onLoadTastingNotes);
  }

  Future<void> _onLoadBottle(
    LoadBottleEvent event,
    Emitter<BottleState> emit,
  ) async {
    emit(BottleLoading());
    try {
      final bottle = await bottleRepository.getBottleById(event.bottleId);
      if (bottle != null) {
        emit(BottleLoaded(bottle));
      } else {
        emit(const BottleError('Bottle not found'));
      }
    } catch (e) {
      emit(BottleError('Failed to load bottle: ${e.toString()}'));
    }
  }

  Future<void> _onLoadTastingNotes(
    LoadTastingNotesEvent event,
    Emitter<BottleState> emit,
  ) async {
    final currentState = state;
    if (currentState is BottleLoaded) {
      emit(TastingNotesLoading(currentState.bottle));
      try {
        final tastingNotes = await bottleRepository.getTastingNotesByBottleId(
          event.bottleId,
        );
        emit(
          TastingNotesLoaded(
            bottle: currentState.bottle,
            tastingNotes: tastingNotes,
          ),
        );
      } catch (e) {
        emit(
          TastingNotesError(
            bottle: currentState.bottle,
            message: 'Failed to load tasting notes: ${e.toString()}',
          ),
        );
      }
    }
  }
}
