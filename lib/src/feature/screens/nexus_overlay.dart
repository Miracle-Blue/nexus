import 'dart:developer';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../common/utils/app_colors.dart';
import '../controllers/nexus_overlay_controller.dart';
import '../widgets/nexus_log_button.dart';

class Nexus extends StatefulWidget {
  const Nexus({
    required this.child,
    this.dio = const <Dio>[],
    this.enable = kDebugMode,
    this.duration = const Duration(milliseconds: 250),
    super.key,
  });

  final bool enable;
  final List<Dio> dio;
  final Duration duration;
  final Widget child;

  @override
  State<Nexus> createState() => _NexusState();
}

class _NexusState extends NexusOverlayController {
  Widget _materialContext() => Row(
        children: <Widget>[
          Expanded(
            child: Visibility(
              visible: !dismissed,
              maintainState: true,
              maintainAnimation: false,
              maintainSize: false,
              maintainInteractivity: false,
              maintainSemantics: false,
              child: Material(
                elevation: 0,
                child: DefaultSelectionStyle(
                  child: ScaffoldMessenger(
                    child: HeroControllerScope.none(
                      child: Navigator(
                        pages: <Page<void>>[
                          MaterialPage<void>(
                            child: Scaffold(
                              backgroundColor: Colors.white,
                              appBar: AppBar(
                                backgroundColor: AppColors.magicalMalachite,
                                centerTitle: false,
                                title: const Text(
                                  'Nexus Network Monitor',
                                  style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 18),
                                ),
                                shadowColor: const Color.fromARGB(255, 201, 202, 206),
                                surfaceTintColor: Colors.transparent,
                                scrolledUnderElevation: 8,
                                actions: [
                                  IconButton(
                                    icon: const Icon(Icons.more_vert),
                                    onPressed: onRemoveLogsTap,
                                    tooltip: 'Clear logs',
                                  ),
                                ],
                              ),
                              body: SafeArea(
                                  child: switch (networkLogs.isEmpty) {
                                true => const Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.cloud_off,
                                          size: 48,
                                          color: AppColors.grayRussian,
                                        ),
                                        Text(
                                          'No logs here yet',
                                          style: TextStyle(color: AppColors.grayRussian, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                false => ListView.builder(
                                    itemCount: networkLogs.length,
                                    itemBuilder: (context, index) => NexusLogButton(
                                      log: networkLogs[networkLogs.length - 1 - index],
                                    ),
                                  ),
                              }),
                            ),
                          ),
                        ],
                        onDidRemovePage: (page) => log('ON DID REMOVE PAGE'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// Handler
          Align(
            alignment: const Alignment(0, -0.4),
            child: SizedBox(
              width: handleWidth,
              height: 64,
              child: Material(
                color: AppColors.magicalMalachite,
                borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
                elevation: 0,
                child: InkWell(
                  onTap: () => controller.toggle(),
                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
                  child: Center(
                    child: RotationTransition(
                      turns: controller.drive(Tween<double>(begin: 0, end: 0.5)),
                      child: const Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => !widget.enable
      ? widget.child
      : LayoutBuilder(
          builder: (context, constraints) {
            final biggest = constraints.biggest;
            final width = math.min<double>(320, biggest.width * 0.85);

            return GestureDetector(
              onHorizontalDragUpdate: (details) => onHorizontalDragUpdate(details, width),
              onHorizontalDragEnd: onHorizontalDragEnd,
              child: Stack(
                children: <Widget>[
                  widget.child,
                  if (!dismissed)
                    AnimatedModalBarrier(
                      color: controller.drive(
                        ColorTween(begin: Colors.transparent, end: Colors.black.withAlpha(127)),
                      ),
                      dismissible: true,
                      semanticsLabel: 'Dismiss',
                      onDismiss: () => controller.hide(),
                    ),
                  PositionedTransition(
                    rect: controller.drive(
                      RelativeRectTween(
                        begin: RelativeRect.fromLTRB(handleWidth - width, 0, biggest.width - handleWidth, 0),
                        end: RelativeRect.fromLTRB(0, 0, biggest.width - width, 0),
                      ),
                    ),
                    child: SizedBox(width: width, child: _materialContext()),
                  ),
                ],
              ),
            );
          },
        );
}
