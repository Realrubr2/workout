// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout/components/heat_map.dart';
import 'package:workout/data/workout_data.dart';
import 'package:workout/pages/workout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
  }

  final newWorkoutController = TextEditingController();

  goToWorkoutPage(String workoutName) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutPage(workoutName: workoutName)));
  }


  void createWorkout() {
    showDialog(
      context: context,
      builder: (context) =>  AlertDialog(
          title: Text('Create a new workout'),
          content:  TextField(
            controller: newWorkoutController,
          ),
          actions: [
//save workout
            MaterialButton(
              onPressed: save,
  
              child: Text('save'),
            ),
//cancel workout
            MaterialButton(
              onPressed: cancel,
              child: const Text('cancel'),
            ),
          ]),
    );
  }

  void save() {
    String workoutName = newWorkoutController.text;
    // save the workout
    Provider.of<WorkoutData>(context, listen: false).addWorkout(workoutName);

    Navigator.pop(context);
    clearController();
  }

  void cancel() {
    // cancel the workout
    Navigator.pop(context);
    clearController();
  }

  clearController(){
    newWorkoutController.clear();
  }



  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Workout App'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createWorkout,
          child: const Icon(Icons.add),
        ),
        body: ListView(
          children: [
            MyHeatMap(datasets: value.heatdatasets, startDateYYYYMMDD: value.getStartDate()),

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
          itemCount: value.getWorkoutList().length,
          itemBuilder: (context, index) => ListTile(
            title: Text(value.getWorkoutList()[index].name),
            trailing: IconButton(icon: Icon(Icons.arrow_forward_ios),
            onPressed: ()=> goToWorkoutPage(value.getWorkoutList()[index].name),),
          ),
        ),
          ],
        )
      ),
    );
  }
}
