import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';
import 'package:stick_control/exercise/exercise.dart';
import 'package:stick_control/exercise/exercise_library.dart';
import 'package:stick_control/exercise/exercise_player.dart';
import 'package:stick_control/render/exercise_render.dart';

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
  ExercisePlayer player = ExercisePlayer();
  double _currentBpm = 100.0;
  Exercise? selectedExercise;
  late ExerciseLibrary library;
  late ExerciseRender noteRender;
  List<DropdownMenuEntry<Exercise>> _exerciseEntries = [];

  _MyHomePageState() {
    noteRender = ExerciseRender(player);
  }

  @override
  void initState() {
    super.initState();
    library = ExerciseLibrary();
    _load();
  }

  void _load() async {
    await Future.wait([library.load(), noteRender.load(), player.load()]);
    print("loaded assets");
    setState(() {
      _exerciseEntries = library.exercises
          .map((e) => DropdownMenuEntry(value: e, label: e.name))
          .toList();
      _selectExercise(library.exercises[0]);
    });
  }

  void _start() {
    if (selectedExercise == null) {
      return;
    }
    player.play();
  }

  void _stop() {
    player.stop();
  }

  void _changeBpm(double value) {
    setState(() {
      _currentBpm = value;
    });
    player.bpm = _currentBpm.round();
  }

  void _selectExercise(Exercise? e) {
    setState(() {
      selectedExercise = e;
    });
    _stop();
    player.init(e!);
    noteRender.init(e!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DropdownMenu(
                width: 300,
                label: const Text("Exercise"),
                dropdownMenuEntries: _exerciseEntries,
                onSelected: _selectExercise,
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(100, 150, 100, 150),
                      child: SpriteWidget(noteRender))),
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
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
