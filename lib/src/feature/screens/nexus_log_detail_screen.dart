import 'package:flutter/material.dart';

import '../../common/models/nexus_network_log.dart';
import '../controllers/nexus_log_detail_controller.dart';

class NexusLogDetailScreen extends StatefulWidget {
  const NexusLogDetailScreen({required this.log, super.key});

  final NexusNetworkLog log;

  @override
  State<NexusLogDetailScreen> createState() => _NexusLogDetailScreenState();
}

class _NexusLogDetailScreenState extends NexusLogDetailController {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'NEXUS - HTTP Request detail',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          bottom: TabBar(
            controller: tabController,
            tabs: const [
              Tab(icon: Icon(Icons.info_outline)),
              Tab(icon: Icon(Icons.arrow_upward_rounded)),
              Tab(icon: Icon(Icons.arrow_downward_rounded)),
              Tab(icon: Icon(Icons.preview_outlined)),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            Text('Overview'),
            Text('Request'),
            Text('Response'),
            Text('Preview'),
          ],
        ),
      );
}
