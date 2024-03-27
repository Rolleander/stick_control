import 'package:flutter/material.dart';
import 'package:stick_control/widgets/app_data.dart';

import 'app_wrapper.dart';
import 'exercise_selection.dart';

class GroupSelection extends StatelessWidget {
  const GroupSelection({super.key, required this.data});

  final AppData data;

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
        title: "Groups",
        child: GridView.count(
          crossAxisCount: 2,
          children: data.library.exercises.keys
              .map((group) => InkWell(
                  onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => ExerciseSelection(
                                      data: data,
                                      group: group,
                                    )))
                      },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Text(group),
                  )))
              .toList(),
        ));
  }
}
