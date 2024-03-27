import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';
import 'package:stick_control/exercise/exercise.dart';
import 'package:stick_control/render/exercise_render.dart';

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
  late ExerciseRender noteRender;

  @override
  void initState() {
    super.initState();
    print("init state");
    _currentBpm = widget.data.bpm.value;
    noteRender = ExerciseRender(widget.data.player, widget.data.textures);
    widget.data.player.init(widget.exercise);
  }

  void _togglePlayer() {
    setState(() {
      playing = !playing;
    });
    if (playing) {
      widget.data.player.play();
    } else {
      widget.data.player.stop();
    }
  }

  void _changeBpm(double value) {
    setState(() {
      _currentBpm = value;
    });
    widget.data.bpm.value = value;
    widget.data.player.bpm = _currentBpm.round();
  }

  void _refreshPlayerRender(BuildContext context) {
    noteRender.context = context;
    noteRender.init(widget.exercise);
  }

  @override
  Widget build(BuildContext context) {
    _refreshPlayerRender(context);
    return AppWrapper(
        title: widget.exercise.name,
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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text(
                '${_currentBpm.round()} BPM',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Slider(
                  value: _currentBpm, min: 10, max: 300, onChanged: _changeBpm),
              FloatingActionButton(
                  onPressed: _togglePlayer,
                  child: Icon(!playing ? Icons.play_arrow : Icons.stop)),
            ]),
          ],
        ));
  }
}
