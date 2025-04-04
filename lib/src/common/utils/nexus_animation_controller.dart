import 'package:flutter/material.dart';

class NexusToolsController extends AnimationController {
  NexusToolsController({
    required super.vsync,
    Duration duration = const Duration(milliseconds: 250),
    super.value,
  }) : super(lowerBound: 0, upperBound: 1, duration: duration);

  TickerFuture show() => forward();

  TickerFuture hide() => reverse();

  @override
  TickerFuture toggle({double? from}) {
    if (from != null) super.value = from;
    switch (status) {
      case AnimationStatus.completed:
      case AnimationStatus.forward:
        return hide();
      case AnimationStatus.reverse:
      case AnimationStatus.dismissed:
        return show();
    }
  }
}
