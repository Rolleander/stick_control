import 'package:flutter/material.dart';
import 'package:stick_control/exercise/exercise.dart';
import 'package:stick_control/exercise/exercise_library.dart';
import 'package:stick_control/exercise/exercise_player.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ExercisePlayer? player;
  double _currentBpm = 100.0;
  Exercise? selectedExercise;
  late ExerciseLibrary library;
  List<DropdownMenuEntry<Exercise>> _exerciseEntries = [];

  @override
  void initState() {
    super.initState();
    library = ExerciseLibrary();
    library.load().whenComplete(() => _exerciseEntries = library.exercises
        .map((e) => DropdownMenuEntry(value: e, label: e.name))
        .toList());
  }

  void _start() {
    _stop();
    if (selectedExercise == null) {
      return;
    }
    player = ExercisePlayer(selectedExercise!);
    player!.bpm = _currentBpm.round();
    player!.init().whenComplete(() => player?.play());
  }

  void _stop() {
    player?.stop();
  }

  void _changeBpm(double value) {
    setState(() {
      _currentBpm = value;
    });
    player?.bpm = _currentBpm.round();
  }

  void _selectExercise(Exercise? e) {
    setState(() {
      selectedExercise = e;
    });
    _stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownMenu(
              width: 300,
              label: const Text("Exercise"),
              dropdownMenuEntries: _exerciseEntries,
              onSelected: _selectExercise,
            ),
            Text(
              '${_currentBpm.round()} BPM',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Slider(
                value: _currentBpm, min: 10, max: 300, onChanged: _changeBpm),
            IconButton(onPressed: _start, icon: const Icon(Icons.play_arrow)),
            IconButton(onPressed: _stop, icon: const Icon(Icons.stop))
          ],
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
