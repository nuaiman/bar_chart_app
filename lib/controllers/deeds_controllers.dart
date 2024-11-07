import 'dart:convert';
import 'dart:ui';

import 'package:bar_chart_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/deed.dart';
import 'default_deeds_controllers.dart';
import 'negative_deeds_controller.dart';
import 'positive_deeds_controller.dart';

class DeedsController extends StateNotifier<List<Deed>> {
  final List<Deed> _positiveDeeds;
  final List<Deed> _negativeDeeds;
  final List<Deed> _defaultDeeds;

  // Shared Preferences Keys
  static const String lastUpdateKey = "lastUpdateDateKey";
  static const String deedsKey = "deedsListKey";

  DeedsController({
    required List<Deed> positiveDeeds,
    required List<Deed> negativeDeeds,
    required List<Deed> defaultDeeds,
  })  : _positiveDeeds = positiveDeeds,
        _negativeDeeds = negativeDeeds,
        _defaultDeeds = defaultDeeds,
        super([]);
  // ---------------------------------------------------------------------------
  Future<List<Deed>> _initializeDefaultDeeds() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getString(lastUpdateKey);

    DateTime lastUpdateDate = lastUpdate != null
        ? DateTime.parse(lastUpdate)
        : DateTime.now()
            .subtract(const Duration(days: 1)); // Default to yesterday

    // Calculate missed days
    List<Deed> missedDeeds = [];
    final today = DateTime.now();

    if (lastUpdateDate.year != today.year ||
        lastUpdateDate.month != today.month ||
        lastUpdateDate.day != today.day) {
      // Add deeds for all missed days
      for (var day = lastUpdateDate.add(const Duration(days: 1));
          day.isBefore(today);
          day = day.add(const Duration(days: 1))) {
        // Add default deeds for each missed day
        for (var deed in _defaultDeeds) {
          missedDeeds.add(
              deed.copyWith(day: day.day, month: day.month, year: day.year));
        }
      }
    }

    // Add deeds for today
    for (var deed in _defaultDeeds) {
      missedDeeds.add(
          deed.copyWith(day: today.day, month: today.month, year: today.year));
    }

    return missedDeeds.toSet().toList();
  }

  Future<List<Deed>> _initializePositiveDeeds() async {
    final prefs = await SharedPreferences.getInstance();

    // Get the list of deed JSON strings from SharedPreferences
    List<String>? deedsJson = prefs.getStringList(deedsKey);

    if (deedsJson == null) {
      return []; // If there are no deeds saved in SharedPreferences, return an empty list
    }

    // Convert the JSON strings into Deed objects
    List<Deed> allDeeds = deedsJson
        .map((deedJson) => Deed.fromJson(jsonDecode(deedJson)))
        .toList();

    // Filter out the deeds with ids 1, 2, 3, 4, 5, 6 and select the ones that are positive (completed == true)
    List<Deed> positiveDeeds = allDeeds.where((deed) {
      return ![1, 2, 3, 4, 5, 6].contains(deed.id) && deed.type == true;
    }).toList();

    return positiveDeeds;
  }

  Future<List<Deed>> _initializeNegativeDeeds() async {
    final prefs = await SharedPreferences.getInstance();

    // Get the list of deed JSON strings from SharedPreferences
    List<String>? deedsJson = prefs.getStringList(deedsKey);

    if (deedsJson == null) {
      return []; // If there are no deeds saved in SharedPreferences, return an empty list
    }

    // Convert the JSON strings into Deed objects
    List<Deed> allDeeds = deedsJson
        .map((deedJson) => Deed.fromJson(jsonDecode(deedJson)))
        .toList();

    // Filter out the deeds with ids 1, 2, 3, 4, 5, 6 and select the ones that are negative (completed == false)
    List<Deed> negativeDeeds = allDeeds.where((deed) {
      return ![1, 2, 3, 4, 5, 6].contains(deed.id) && deed.type == false;
    }).toList();

    return negativeDeeds;
  }

  Future<void> _updateLastUpdateDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(lastUpdateKey, DateTime.now().toIso8601String());
  }

  Future<void> loadDeeds(BuildContext context) async {
    List<Deed> defaultDeeds = await _initializeDefaultDeeds();
    List<Deed> positiveDeeds = await _initializePositiveDeeds();
    List<Deed> negativeDeeds = await _initializeNegativeDeeds();
    await _updateLastUpdateDate();
    state = [...defaultDeeds, ...positiveDeeds, ...negativeDeeds];

    print('--------------------------');
    print(_defaultDeeds.length);
    print(state.length);
    print('--------------------------');
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false);
    }
  }

  // ---------------------------------------------------------------------------
  Future<void> _showDeedDialog(BuildContext context, String message,
      {bool isError = false}) async {
    showDialog(
      context: context,
      barrierColor: Colors.white.withOpacity(0.1),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 70.0),
                      child: Text(
                        message,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isError ? Colors.red : Colors.green,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isError ? Colors.red : Colors.green,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _updateDeedsAndLastUpdateDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(deedsKey);

      // Save updated deeds
      List<String> deedsJson =
          state.map((deed) => jsonEncode(deed.toJson())).toList();
      await prefs.setStringList(deedsKey, deedsJson);

      // Update last update date
      await prefs.setString(lastUpdateKey, DateTime.now().toIso8601String());
    } catch (e) {
      // Handle any errors here (e.g., log or show an error message)
      print("Error updating deeds or last update date: $e");
    }
  }

  Future<void> addDeed(Deed deed, BuildContext context) async {
    try {
      state = [...state, deed];
      await _updateDeedsAndLastUpdateDate();
      // Show success message after deed is added
      await _showDeedDialog(context, 'Deed Added Successfully', isError: false);
    } catch (e) {
      // Show error message if something goes wrong
      await _showDeedDialog(context, 'Failed to Add Deed: $e', isError: true);
    }
  }

  Future<void> removeDeed(Deed deed, BuildContext context) async {
    try {
      state = state.where((d) => d != deed).toList();
      await _updateDeedsAndLastUpdateDate();
      // Show success message after deed is removed
      await _showDeedDialog(context, 'Deed Removed Successfully',
          isError: false);
    } catch (e) {
      // Show error message if something goes wrong
      await _showDeedDialog(context, 'Failed to Remove Deed: $e',
          isError: true);
    }
  }

  // ---------------------------------------------------------------------------
  bool hasThisDeed(Deed deed) {
    return state.any((d) {
      return d.id == deed.id &&
          d.type == deed.type &&
          d.year == deed.year &&
          d.month == deed.month &&
          d.day == deed.day &&
          d.id == deed.id;
    });
  }

  int getDeedWithSameIdAndTypeCount(int id, bool type) {
    final today = DateTime.now();
    return state
        .where((deed) =>
            deed.id == id &&
            deed.type == type &&
            deed.day == today.day &&
            deed.month == today.month &&
            deed.year == today.year)
        .length;
  }
  // ---------------------------------------------------------------------------
  // ---------------------------------------------------------------------------
  // ---------------------------------------------------------------------------
  // ---------------------------------------------------------------------------
}

// -----------------------------------------------------------------------------
final deedsProvider = StateNotifierProvider<DeedsController, List<Deed>>((ref) {
  final positiveDeeds = ref.read(positiveDeedsProvider);
  final negativeDeeds = ref.read(negativeDeedsProvider);
  final defaultDeeds = ref.read(defaultDeedsProvider);
  return DeedsController(
    positiveDeeds: positiveDeeds,
    negativeDeeds: negativeDeeds,
    defaultDeeds: defaultDeeds,
  );
});
