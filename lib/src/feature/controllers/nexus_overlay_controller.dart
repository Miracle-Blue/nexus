import 'package:flutter/material.dart';

import '../../../nexus.dart';
import '../../common/utils/nexus_animation_controller.dart';

abstract class NexusOverlayController extends State<Nexus> with SingleTickerProviderStateMixin {
  late final NexusToolsController controller;
  double handleWidth = 16;
  bool dismissed = true;

  @override
  void initState() {
    super.initState();
    controller = NexusToolsController(value: 0, duration: widget.duration, vsync: this);
    controller.addStatusListener(_onStatusChanged);
    _onStatusChanged(controller.status);
  }

  @override
  void didUpdateWidget(covariant Nexus oldWidget) {
    if (widget.enable) {
      dismissed = controller.status == AnimationStatus.dismissed;
    } else {
      dismissed = true;
    }
    if (widget.duration != oldWidget.duration) {
      controller.duration = widget.duration;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller
      ..removeStatusListener(_onStatusChanged)
      ..dispose();

    super.dispose();
  }

  void _onStatusChanged(AnimationStatus status) {
    if (!mounted) return;
    switch (status) {
      case AnimationStatus.dismissed:
        if (dismissed) return;
        setState(() => dismissed = true);
      default:
        if (!dismissed) return;
        setState(() => dismissed = false);
    }
  }

  void onHorizontalDragUpdate(DragUpdateDetails details, double width) {
    if (dismissed) return;

    final delta = details.delta.dx;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final isLtr = Directionality.of(context) == TextDirection.ltr;

    if (dismissed && (isRtl ? delta < 0 : delta > 0) || !dismissed && (isRtl ? delta > 0 : delta < 0)) {
      final newValue = controller.value + delta / width * (isRtl ? -1 : 1);
      controller.value = newValue.clamp(0.0, 1.0);
    }

    if (dismissed && (isLtr ? delta < 0 : delta > 0) || !dismissed && (isLtr ? delta > 0 : delta < 0)) {
      final newValue = controller.value - delta / width * (isLtr ? -1 : 1);
      controller.value = newValue.clamp(0.0, 1.0);
    }
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    if (dismissed) return;

    final velocity = details.primaryVelocity ?? 0;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    if ((isRtl ? -velocity : velocity) > 300 || controller.value > 0.5) {
      controller.show();
    } else {
      controller.hide();
    }
  }
}
