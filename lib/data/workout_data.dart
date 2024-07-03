import 'package:flutter/material.dart';
import 'package:workout/data/date_time.dart';
import 'package:workout/models/exercise.dart';
import 'hive_database.dart';
import '../models/workout.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();

  List<Workout> workoutList = [
    Workout(name: 'UpperBody', exercises: [
      Exercise(
        name: 'biceps',
        sets: 10,
        reps: 2,
        weight: 10,
      )
    ])
  ];
// get the list of workouts

  List<Workout> getWorkoutList() {
    return workoutList;
  }

  //first tiume the app has been opened
  initializeWorkoutList() {
    if (db.previousData()) {
      workoutList = db.readFromDatabase();
    } else {
      db.saveToDatabase(workoutList);
    }

    loadHeatMapData();
  }

  numberOfExersizesInWorkout(String workoutName) {
    // find the relevant workout in the list
    Workout relevantWorkout = findRelevantWorkout(workoutName);

    return relevantWorkout.exercises.length;
  }

//add a workout
  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercises: []));
    notifyListeners();
    db.saveToDatabase(workoutList);
  }

//add an exercise to a workout

  void addExercise(
      String workoutName, String exerciseName, int weight, int sets, int reps) {
    // find the relevant workout in the list
    Workout relevantWorkout = findRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
        Exercise(name: exerciseName, weight: weight, sets: sets, reps: reps));
    notifyListeners();
    db.saveToDatabase(workoutList);
  }

// check off the exersice as completed
  void checkOffExercise(String workoutName, String exerciseName) {
    // find the relevant workout in the list

    // find the relevant exercise in the workout
    Exercise relevantExercise = findRelevantExercise(workoutName, exerciseName);
    // toggle the isCompleted property
    relevantExercise.isCompleted = !relevantExercise.isCompleted;
    notifyListeners();
    db.saveToDatabase(workoutList);
    loadHeatMapData();
  }

//find relevantworkoiut
  findRelevantWorkout(String workoutName) {
    return workoutList.firstWhere((workout) => workout.name == workoutName);
  }

  findRelevantExercise(String workoutName, String exerciseName) {
    // find the relevant workout in the list
    Workout relevantWorkout = findRelevantWorkout(workoutName);

    // find the relevant exercise in the workout
    return relevantWorkout.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);
  }

// get the startdate
  String getStartDate() {
    return db.getStartDate();
  }

  Map<DateTime, int> heatdatasets = {};
  void loadHeatMapData() {
    DateTime startDate = createDateFromString(getStartDate());

    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateToString(startDate.add(Duration(days: i)));

      int completionStatus = db.getCompletionStatus(yyyymmdd);

      int year = startDate.add(Duration(days: i)).year;
      int month = startDate.add(Duration(days: i)).month;
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = {DateTime(year, month, day): completionStatus};

      heatdatasets.addEntries(percentForEachDay.entries);
    }
  }
}
