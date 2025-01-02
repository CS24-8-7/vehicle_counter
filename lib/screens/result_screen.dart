import 'package:vehicle_counter/imports_library.dart';


class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VehicleCounterProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle), // Localization for "Vehicle Counter"
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
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: directions.entries.map((directionEntry) {
                  final direction = directionEntry.key;
                  final count = directionEntry.value;
                  final directionIcon = _getDirectionIcon(direction);
                  final directionLabel = _getDirectionLabel(l10n, direction);

                  return Row(
                    children: [
                      Icon(directionIcon, size: 16), // Add the direction icon
                      const SizedBox(width: 8), // Space between icon and text
                      Text(
                        '$directionLabel: $count',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getDirectionLabel(AppLocalizations l10n, String direction) {
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

  IconData _getDirectionIcon(String direction) {
    switch (direction) {
      case 'East':
        return Icons.arrow_back ;
      case 'West':
        return Icons.arrow_forward;
      case 'North':
        return Icons.arrow_upward;

      case 'South':
        return Icons.arrow_downward;

      default:
        return Icons.help;
    }
  }
}
