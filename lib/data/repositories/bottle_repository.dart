import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/network/network_info.dart';
import '../../core/storage/storage_service.dart';
import '../models/bottle.dart';
import '../models/tasting_note.dart';

abstract class BottleRepository {
  Future<List<Bottle>> getBottles();
  Future<Bottle?> getBottleById(String id);
  Future<List<TastingNote>> getTastingNotesByBottleId(String bottleId);
}

class BottleRepositoryImpl implements BottleRepository {
  final NetworkInfo networkInfo;
  final StorageService storageService;

  BottleRepositoryImpl({
    required this.networkInfo,
    required this.storageService,
  });

  @override
  Future<List<Bottle>> getBottles() async {
    // Check if we're online
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      // Fetch from "remote" (mock JSON file)
      try {
        final String jsonData = await rootBundle.loadString(
          'assets/data/bottles.json',
        );
        final List<dynamic> data = json.decode(jsonData);
        final bottles = data.map((json) => Bottle.fromJson(json)).toList();

        // Store fresh data locally
        await storageService.saveData('bottles', jsonData);

        return bottles;
      } catch (e) {
        // If remote fetch fails, try to get from local storage
        return _getBottlesFromLocalStorage();
      }
    } else {
      // If offline, get from local storage
      return _getBottlesFromLocalStorage();
    }
  }

  Future<List<Bottle>> _getBottlesFromLocalStorage() async {
    final jsonData = storageService.getData<String>('bottles');

    if (jsonData != null) {
      final List<dynamic> data = json.decode(jsonData);
      return data.map((json) => Bottle.fromJson(json)).toList();
    }

    return [];
  }

  @override
  Future<Bottle?> getBottleById(String id) async {
    final bottles = await getBottles();
    return bottles.isNotEmpty
        ? bottles.firstWhere(
          (bottle) => bottle.id == id,
          orElse: () => bottles[0],
        )
        : null;
  }

  @override
  Future<List<TastingNote>> getTastingNotesByBottleId(String bottleId) async {
    // Check if we're online
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      // Fetch from "remote" (mock JSON file)
      try {
        final String jsonData = await rootBundle.loadString(
          'assets/data/tasting_notes.json',
        );
        final List<dynamic> data = json.decode(jsonData);
        final allNotes =
            data.map((json) => TastingNote.fromJson(json)).toList();

        // Filter notes for specific bottle
        final bottleNotes =
            allNotes.where((note) => note.bottleId == bottleId).toList();

        // Store fresh data locally
        await storageService.saveData(
          'tasting_notes_$bottleId',
          jsonEncode(bottleNotes),
        );

        return bottleNotes;
      } catch (e) {
        // If remote fetch fails, try to get from local storage
        return _getTastingNotesFromLocalStorage(bottleId);
      }
    } else {
      // If offline, get from local storage
      return _getTastingNotesFromLocalStorage(bottleId);
    }
  }

  Future<List<TastingNote>> _getTastingNotesFromLocalStorage(
    String bottleId,
  ) async {
    final jsonData = storageService.getData<String>('tasting_notes_$bottleId');

    if (jsonData != null) {
      final List<dynamic> data = json.decode(jsonData);
      return data.map((json) => TastingNote.fromJson(json)).toList();
    }

    return [];
  }
}
