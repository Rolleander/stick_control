import 'package:flutter/material.dart';
import 'package:stick_control/storage/storage.dart';
import 'package:stick_control/widgets/app_data.dart';
import 'package:stick_control/widgets/app_wrapper.dart';
import 'package:stick_control/widgets/exercise_widget.dart';
import 'package:stick_control/widgets/group_selection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AppData data = AppData();
  bool loading = true;

  _MyHomePageState();

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _openPreviousExercise() {
    if (!data.library.exercises.containsKey(storage.config.lastGroup)) {
      return;
    }
    var group = data.library.exercises[storage.config.lastGroup];
    var exercise = group.toList()[storage.config.lastExerciseIndex];
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => ExerciseWidget(
                  data: data,
                  exercise: exercise,
                )));
  }

  Future<void> _load() async {
    await data.load();
    setState(() {
      loading = false;
    });
    _openPreviousExercise();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const AppWrapper(
          title: "Loading...", child: CircularProgressIndicator());
    } else {
      return GroupSelection(data: data);
    }
  }
}
