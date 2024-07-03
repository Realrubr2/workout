import 'package:workout/data/date_time.dart';
import 'package:hive/hive.dart'; // Import the hive package
import '../models/workout.dart';
import '../models/exercise.dart';
class HiveDatabase {
  //refrence our hivebox
  final _myBox = Hive.box('workout_database');

  // check if there is data stored
bool previousData() {
  if (_myBox.isEmpty) {
    // ignore: avoid_print
    print('data does not exists');
    _myBox.put('startDate', todaysDate());
    return false;
  } else {
    // ignore: avoid_print
    print('data exists');
    return true;
  }
}

// return our start date
String getStartDate(){
  return _myBox.get('startDate');
}


//write data
void saveToDatabase(List<Workout> workouts) {


  // check if exercises has been done

  bool exerciseCompleted(List<Workout> workouts){
    for(Workout workout in workouts){
      for(Exercise exercise in workout.exercises){
        if(exercise.isCompleted){
          return true;
        }
      }
    }
    return false;
  }
  if(exerciseCompleted(workouts)){
    // ignore: prefer_interpolation_to_compose_strings
    _myBox.put('completionStatus' + todaysDate(), 1);
  } else {
    // ignore: prefer_interpolation_to_compose_strings
    _myBox.put('completionStatus' + todaysDate(), 0);
  }
  

  _myBox.put('workouts', convertWorkoutsToString(workouts));
  _myBox.put('exercises', convertExercisesToString(workouts));
  


}

//read data
List<Workout> readFromDatabase() {
List<Workout> savedWorkouts = [];
List<String> workoutList = _myBox.get('workouts');
List<String> exerciseList = _myBox.get('exercises');


  // throw FormatException(exerciseList.toString() + ' is empty');
 for (int i = 0; i < workoutList.length; i++) {
    List<Exercise> exercises = [];

    // Assuming each workout corresponds to a sublist of exercises
    // This part needs adjustment based on your actual data structure
    for (int j = 0; j < exerciseList.length; j++) {
      var exerciseData = exerciseList[j];
      if (exerciseData is List<dynamic> && exerciseData.isNotEmpty) {
        Exercise exercise = Exercise(
          name: exerciseData[0],
          weight: int.parse(exerciseData[1]),
          sets: int.parse(exerciseData[2]),
          reps: int.parse(exerciseData[3]),
          isCompleted: bool.parse(exerciseData[4]),
        );
        exercises.add(exercise);
      }
    }
    savedWorkouts.add(Workout(name: workoutList[i], exercises: exercises));
  }
return savedWorkouts;
  // ignore: use_function_type_syntax_for_parameters
}

Exercise parseExercise(String serializedExercise) {
  // Split the serialized string into components.
  // Assuming the format is "name,weight,sets,reps,isCompleted"
  
  if (serializedExercise.isEmpty) {
    throw FormatException('The serialized exercise string is empty.', serializedExercise);
  }
  
  List<String> attributes = serializedExercise.split(',');

  if (attributes.length != 5) {
    throw FormatException('Invalid serialized exercise format. Expected format: "name,weight,sets,reps,isCompleted"', serializedExercise);
  }
  // Parse each attribute. Adjust parsing as necessary based on your data format.
  String name = attributes[0];
  int weight = int.parse(attributes[1]);
  int sets = int.parse(attributes[2]);
  int reps = int.parse(attributes[3]);
  bool isCompleted = attributes[4].toLowerCase() == 'true';

  // Create and return an Exercise object.
  return Exercise(
    name: name,
    weight: weight,
    sets: sets,
    reps: reps,
    isCompleted: isCompleted,
  );
}

int getCompletionStatus(String date){
  // ignore: prefer_interpolation_to_compose_strings
  return _myBox.get('completionStatus' + date);
}
}
//return the completionstatus of a given date


// converts workout objects into a list [ upperbody, lowerbody, core, cardio]

List<String> convertWorkoutsToString(List<Workout> workouts) {
  List<String> workoutList = [];
  for (Workout workout in workouts) {
    workoutList.add(workout.name);
  }
  return workoutList;
}

// converts the exercises into a list of strings [name, weight, sets, reps, isCompleted]

List<String> convertExercisesToString(List<Workout> workouts) {
  List<String> exerciseList = [];

  for (Workout workout in workouts) {
  List<Exercise> exercises = workout.exercises;

  List<List<String>> individualWorkout = [];

  for (Exercise exercise in exercises) {
    List<String> individualExercise = [];
    individualExercise.add(exercise.name);
    individualExercise.add(exercise.weight.toString());
    individualExercise.add(exercise.sets.toString());
    individualExercise.add(exercise.reps.toString());
    individualExercise.add(exercise.isCompleted.toString());
    individualWorkout.add(individualExercise);
  } 
  exerciseList.add(individualWorkout.toString());
  }

  return exerciseList;
}