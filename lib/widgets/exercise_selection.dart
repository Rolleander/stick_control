import 'package:flutter/material.dart';
import 'package:stick_control/widgets/exercise_widget.dart';

import 'app_data.dart';
import 'app_wrapper.dart';

class ExerciseSelection extends StatelessWidget {
  const ExerciseSelection({super.key, required this.data, required this.group});

  final AppData data;
  final String group;

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
        title: "Exercises",
        child: ListView(
          padding: const EdgeInsets.all(5),
          children: data.library.exercises[group]
              .map((exercise) => InkWell(
                  onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => ExerciseWidget(
                                      data: data,
                                      exercise: exercise,
                                    )))
                      },
                  child: Text(exercise.name)))
              .toList(),
        ));
  }
}
