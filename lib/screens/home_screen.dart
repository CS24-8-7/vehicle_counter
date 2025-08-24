import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vehicle_counter/widget/custom_dialog.dart';
import '../providers/locale_provider.dart';
import '../providers/vehicle_counter_provider.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _addNewVehicleType() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text(l10n.addVehicle),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(hintText: l10n.addVehicle),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submitAdd(controller.text),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => _submitAdd(controller.text),
              child: Text(l10n.add),
            ),
          ],
        );
      },
    );
  }

  void _submitAdd(String value) {
    final l10n = AppLocalizations.of(context)!;
    final ok = context.read<VehicleCounterProvider>().addVehicle(value);
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.vehicleTypeExists)),
      );
    }
    Navigator.of(context).maybePop();
  }

  void _confirmReset() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetCounter),
        content: Text(l10n.resetCountersConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.no),
          ),
          TextButton(
            onPressed: () {
              context.read<VehicleCounterProvider>().resetCounters();
              Navigator.pop(context);
            },
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String vehicleType) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteVehicle),
        content: Text(l10n.deleteVehicleConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<VehicleCounterProvider>().removeVehicle(vehicleType);
              Navigator.pop(context);
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleCounterProvider>();
    final l10n = AppLocalizations.of(context)!;

    // اتجاهات العرض ثابتة للـ Header العام
    const directions = ['East', 'West', 'North', 'South'];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        leading: IconButton(
          icon: const Icon(Icons.language),
          onPressed: () => context.read<LocaleProvider>().toggleLocale(),
          tooltip: l10n.toggleLanguage,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.assessment),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ResultsPage()),
            ),
            tooltip: l10n.viewResults,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'reset':
                  _confirmReset();
                  break;
                case 'add':
                  _addNewVehicleType();
                  break;
                case 'about':
                  showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                      title: l10n.title_contact,
                      message: l10n.message_contact,
                      icon: Icons.info_outline,
                      onClose: () => Navigator.pop(context),
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'reset',
                child: ListTile(
                  leading: const Icon(Icons.refresh),
                  title: Text(l10n.resetCounter),
                ),
              ),
              PopupMenuItem(
                value: 'add',
                child: ListTile(
                  leading: const Icon(Icons.add),
                  title: Text(l10n.addVehicle),
                ),
              ),
              PopupMenuItem(
                value: 'about',
                child: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.aboutUs),
                ),
              ),
            ],
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Header عام أعلى الصفحة
          SliverToBoxAdapter(
            child: _GlobalHeader(directions: directions),
          ),

          // قائمة المركبات
          SliverList.builder(
            itemCount: provider.counters.length,
            itemBuilder: (context, index) {
              final vehicleType = provider.counters.keys.elementAt(index);
              return _VehicleRowCard(
                vehicleType: vehicleType,
                onLongPress: () => _confirmDelete(vehicleType),
                directions: directions,
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewVehicleType,
        child: const Icon(Icons.add),
        tooltip: l10n.add,
        shape: const CircleBorder(),
      ),
    );
  }
}

class _GlobalHeader extends StatelessWidget {
  final List<String> directions;
  const _GlobalHeader({required this.directions});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      elevation: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        width: double.infinity,
        child: Row(
          children: [
            for (final d in directions)
              Expanded(
                child: Center(
                  child: _HeaderCell(
                    label: _labelFor(l10n, d),
                    icon: _iconFor(d, isRTL),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
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
}

class _VehicleRowCard extends StatelessWidget {
  final String vehicleType;
  final VoidCallback onLongPress;
  final List<String> directions;

  const _VehicleRowCard({
    required this.vehicleType,
    required this.onLongPress,
    required this.directions,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleCounterProvider>();
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  for (final d in directions)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _DirectionButton(
                          vehicleType: vehicleType,
                          direction: d,
                          count: provider.counters[vehicleType]?[d] ?? 0,
                          onPressed: () =>
                              provider.incrementCounter(vehicleType, d),
                          icon: _iconFor(d, isRTL),
                          label: _labelFor(l10n, d),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // اسم المركبة في أسفل البطاقة
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.06),
                borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Text(
                provider.vehicleLabels[vehicleType] ?? vehicleType,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final IconData icon;
  const _HeaderCell({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelLarge;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: style,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _DirectionButton extends StatelessWidget {
  final String vehicleType;
  final String direction;
  final int count;
  final VoidCallback onPressed;
  final IconData icon;
  final String label;

  const _DirectionButton({
    super.key,
    required this.vehicleType,
    required this.direction,
    required this.count,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        side: BorderSide(color: cs.primary.withOpacity(0.25)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$count',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}