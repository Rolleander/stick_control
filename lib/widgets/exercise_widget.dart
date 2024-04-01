import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';
import 'package:stick_control/exercise/exercise.dart';
import 'package:stick_control/render/exercise_render.dart';
import 'package:stick_control/storage/storage.dart';

import 'app_data.dart';
import 'app_wrapper.dart';

class ExerciseWidget extends StatefulWidget {
  const ExerciseWidget({super.key, required this.data, required this.exercise});

  final AppData data;
  final Exercise exercise;

  @override
  State<ExerciseWidget> createState() => _ExerciseWidgetState();
}

class _ExerciseWidgetState extends State<ExerciseWidget> {
  double _currentBpm = 100.0;
  var playing = false;
  var playModesSelected = [true, true];
  late ExerciseRender noteRender;

  @override
  void initState() {
    super.initState();
    _currentBpm = widget.data.bpm.value;
    noteRender = ExerciseRender(widget.data.player, widget.data.textures);
    widget.data.initExercise(widget.exercise);
    storage.config.lastGroup = widget.exercise.group;
    storage.config.lastExerciseIndex = widget
        .data.library.exercises[widget.exercise.group]
        .toList()
        .indexOf(widget.exercise);
    storage.updateConfig();
  }

  void _togglePlayer() {
    setState(() {
      playing = !playing;
    });
    if (playing) {
      widget.data.playerStart();
    } else {
      widget.data.playerStop();
    }
  }

  void _changeBpm(double value) {
    setState(() {
      _currentBpm = value;
    });
    widget.data.bpm.value = value;
  }

  void _refreshPlayerRender(BuildContext context) {
    noteRender.context = context;
    noteRender.init(widget.exercise);
  }

  void _playModePressed(int index) {
    setState(() {
      playModesSelected[index] = !playModesSelected[index];
    });
    widget.data.player.muted = !playModesSelected[0];
    widget.data.metronome.muted = !playModesSelected[1];
  }

  @override
  Widget build(BuildContext context) {
    _refreshPlayerRender(context);
    return AppWrapper(
        title: widget.exercise.name,
        child: PopScope(
            onPopInvoked: (popped) => widget.data.playerStop(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(50, 150, 50, 200),
                        child: SpriteWidget(
                          noteRender,
                          transformMode: SpriteBoxTransformMode.fixedWidth,
                        ))),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        '${_currentBpm.round()} BPM',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Slider(
                          value: _currentBpm,
                          min: 10,
                          max: 300,
                          onChanged: _changeBpm),
                      ToggleButtons(
                          isSelected: playModesSelected,
                          onPressed: _playModePressed,
                          children: const [
                            Icon(Icons.music_note),
                            Icon(Icons.timer_sharp)
                          ]),
                      FloatingActionButton(
                          onPressed: _togglePlayer,
                          child:
                              Icon(!playing ? Icons.play_arrow : Icons.stop)),
                    ]),
              ],
            )));
  }
}
