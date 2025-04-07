import 'package:equatable/equatable.dart';

abstract class BottleEvent extends Equatable {
  const BottleEvent();

  @override
  List<Object> get props => [];
}

class LoadBottleEvent extends BottleEvent {
  final String bottleId;

  const LoadBottleEvent(this.bottleId);

  @override
  List<Object> get props => [bottleId];
}

class LoadTastingNotesEvent extends BottleEvent {
  final String bottleId;

  const LoadTastingNotesEvent(this.bottleId);

  @override
  List<Object> get props => [bottleId];
}
