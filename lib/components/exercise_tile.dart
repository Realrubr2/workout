import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final int weight;
  final int sets;
  final int reps;
  final bool isCompleted;
  void Function(bool?)? onCheckboxChanged;

  ExerciseTile({
    super.key,
    required this.exerciseName,
    required this.weight,
    required this.sets,
    required this.reps,
    required this.isCompleted,
    required this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.primaries.first[100],
      child: ListTile(
        title: Text(exerciseName),
        subtitle: Row(
          children: [
            //sets
            Chip(
                backgroundColor: Colors.blue,
                label: Text(
                  "sets:$sets",
                )),
            //reps
            Chip(backgroundColor: Colors.blue, label: Text("reps: $reps")),
            //weight
            Chip(backgroundColor: Colors.blue, label: Text("weight: $weight")),
          ],
        ),
        trailing: Checkbox(
          value: isCompleted,
          onChanged: (value) => onCheckboxChanged!(value),
        ),
      ),
    );
  }
}
