// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/components/exercise_tile.dart';
import 'package:workout/data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  void onCheckBoxChange(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  final newExerciseController = TextEditingController();
  final newWeightController = TextEditingController();
  final newRepsController = TextEditingController();
  final newSetsController = TextEditingController();
  void createNewExercise() {
    // create a new exercise
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('add new exercise'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Exercise Name',
              ),
              controller: newExerciseController,
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Weight',
              ),
              controller: newWeightController,
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Sets',
              ),
              controller: newSetsController,
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Reps',
              ),
              controller: newRepsController,
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: saveExercise,
            child: Text('save'),
          ),
          MaterialButton(
            onPressed: cancelExercise,
            child: const Text('cancel'),
          ),
        ],
      ),
    );
  }

  void saveExercise() {
    if(newExerciseController.text.isEmpty || newWeightController.text.isEmpty || newSetsController.text.isEmpty || newRepsController.text.isEmpty){
      return;
    } else if(isNumeric(newWeightController.text) || isNumeric(newSetsController.text)|| isNumeric(newRepsController.text)){
      throw Exception('Please enter a number');
    }

    // save the workout
    Provider.of<WorkoutData>(context, listen: false).addExercise(
        widget.workoutName,
        newExerciseController.text,
        int.parse(newWeightController.text),
        int.parse(newSetsController.text),
        int.parse(newRepsController.text));

    Navigator.pop(context);
    clearController();
  }

  void cancelExercise() {
    // cancel the workout
    Navigator.pop(context);
    clearController();
  }

  clearController() {
    newExerciseController.clear();
    newWeightController.clear();
    newSetsController.clear();
    newRepsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.workoutName),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExercise,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
            itemCount: value.numberOfExersizesInWorkout(widget.workoutName),
            itemBuilder: (context, index) => ExerciseTile(
                  exerciseName: value
                      .findRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .name,
                  weight: value
                      .findRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .weight,
                  sets: value
                      .findRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .sets,
                  reps: value
                      .findRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .reps,
                  isCompleted: value
                      .findRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .isCompleted,
                  onCheckboxChanged: (isChecked) => onCheckBoxChange(
                      widget.workoutName,
                      value
                          .findRelevantWorkout(widget.workoutName)
                          .exercises[index]
                          .name),
                )),
      ),
    );
  }

  bool isNumeric(String s) {
 if (s == null) {
   return false;
 }
 return double.tryParse(s) != null;
}

}
