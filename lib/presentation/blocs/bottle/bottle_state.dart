import 'package:equatable/equatable.dart';

import '../../../data/models/bottle.dart';
import '../../../data/models/tasting_note.dart';

abstract class BottleState extends Equatable {
  const BottleState();

  @override
  List<Object> get props => [];
}

class BottleInitial extends BottleState {}

class BottleLoading extends BottleState {}

class BottleLoaded extends BottleState {
  final Bottle bottle;

  const BottleLoaded(this.bottle);

  @override
  List<Object> get props => [bottle];
}

class BottleError extends BottleState {
  final String message;

  const BottleError(this.message);

  @override
  List<Object> get props => [message];
}

class TastingNotesLoading extends BottleState {
  final Bottle bottle;

  const TastingNotesLoading(this.bottle);

  @override
  List<Object> get props => [bottle];
}

class TastingNotesLoaded extends BottleState {
  final Bottle bottle;
  final List<TastingNote> tastingNotes;

  const TastingNotesLoaded({required this.bottle, required this.tastingNotes});

  @override
  List<Object> get props => [bottle, tastingNotes];
}

class TastingNotesError extends BottleState {
  final Bottle bottle;
  final String message;

  const TastingNotesError({required this.bottle, required this.message});

  @override
  List<Object> get props => [bottle, message];
}
