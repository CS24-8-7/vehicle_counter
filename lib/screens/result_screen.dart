import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/vehicle_counter_provider.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleCounterProvider>();
    final l10n = AppLocalizations.of(context)!;
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: provider.counters.entries.map((entry) {
          final vehicleType = entry.key;
          final directions = entry.value;

          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(
                provider.vehicleLabels[vehicleType] ?? vehicleType,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: directions.entries.map((d) {
                    final direction = d.key;
                    final count = d.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_iconFor(direction, isRTL), size: 16),
                          const SizedBox(width: 8),
                          Text('${_labelFor(l10n, direction)}: $count'),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  static IconData _iconFor(String direction, bool isRTL) {
    switch (direction) {
      case 'East':
        return isRTL ? Icons.arrow_back : Icons.arrow_forward;
      case 'West':
        return isRTL ? Icons.arrow_forward : Icons.arrow_back;
      case 'North':
        return Icons.arrow_upward;
      case 'South':
        return Icons.arrow_downward;
      default:
        return Icons.help_outline;
    }
  }

  static String _labelFor(AppLocalizations l10n, String direction) {
    switch (direction) {
      case 'East':
        return l10n.directionEast;
      case 'West':
        return l10n.directionWest;
      case 'North':
        return l10n.directionNorth;
      case 'South':
        return l10n.directionSouth;
      default:
        return direction;
    }
  }
}
