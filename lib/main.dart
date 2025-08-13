import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(const ImcApp());

class ImcApp extends StatelessWidget {
  const ImcApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMC Calculator',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        brightness: Brightness.light,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.teal.withOpacity(0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: const ImcPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ImcPage extends StatefulWidget {
  const ImcPage({super.key});
  @override
  State<ImcPage> createState() => _ImcPageState();
}

class _ImcPageState extends State<ImcPage> {
  final _wCtrl = TextEditingController();
  final _hCtrl = TextEditingController();
  double? _bmi;
  String _category = '—';
  String _asset = 'assets/img/normal.png';

  @override
  void dispose() {
    _wCtrl.dispose();
    _hCtrl.dispose();
    super.dispose();
  }

  void _calc() {
    final w = double.tryParse(_wCtrl.text.replaceAll(',', '.'));
    final h = double.tryParse(_hCtrl.text.replaceAll(',', '.'));
    if (w == null || h == null || w <= 0 || h <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez entrer un poids (kg) et une taille (m) valides.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final bmi = w / math.pow(h, 2);
    final c = _categoryFor(bmi);
    setState(() {
      _bmi = bmi;
      _category = c.$1;
      _asset = c.$2;
    });
  }

  /// Returns (label, assetPath)
  (String, String) _categoryFor(double bmi) {
    if (bmi < 18.5) {
      return ('Maigreur', 'assets/img/maigreur.png');
    } else if (bmi < 25) {
      return ('Normal', 'assets/img/normal.png');
    } else if (bmi < 30) {
      return ('Surpoids', 'assets/img/surpoids.png');
    } else if (bmi < 40) {
      return ('Obésité modérée', 'assets/img/obesite_moderee.png');
    } else {
      return ('Obésité sévère', 'assets/img/obesite_severe.png');
    }
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.teal, size: 20),
      ),
    );
  }

  Widget _buildBmiCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: isDark ? Colors.teal.shade900.withOpacity(0.7) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Text(
                _bmi == null ? '—' : _bmi!.toStringAsFixed(1),
                key: ValueKey(_bmi),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 5),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, anim) =>
                  FadeTransition(opacity: anim, child: child),
              child: Text(
                _category,
                key: ValueKey(_category),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal.shade800,
                ),
              ),
            ),
            const SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 1,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Image.asset(
                  _asset,
                  key: ValueKey(_asset),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '<18.5 ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
                fontSize: 12,
              ),
            ),
            TextSpan(
              text: 'Maigreur  |  ',
              style: TextStyle(color: Colors.black87, fontSize: 12),
            ),
            TextSpan(
              text: '18.5–25 ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: 12,
              ),
            ),
            TextSpan(
              text: 'Normal  |  ',
              style: TextStyle(color: Colors.black87, fontSize: 12),
            ),
            TextSpan(
              text: '25–30 ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.amber,
                fontSize: 12,
              ),
            ),
            TextSpan(
              text: 'Surpoids  |  ',
              style: TextStyle(color: Colors.black87, fontSize: 12),
            ),
            TextSpan(
              text: '30–40 ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
                fontSize: 12,
              ),
            ),
            TextSpan(
              text: 'Obésité modérée  |  ',
              style: TextStyle(color: Colors.black87, fontSize: 12),
            ),
            TextSpan(
              text: '>40 ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 12,
              ),
            ),
            TextSpan(
              text: 'Obésité sévère',
              style: TextStyle(color: Colors.black87, fontSize: 12),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Calculateur IMC', style: TextStyle(fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.teal.withOpacity(0.85),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        ),
        toolbarHeight: 44,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.teal.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 340),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 60, 12, 12),
              children: [
                Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                    child: Column(
                      children: [
                        _buildInputField(
                          label: 'Poids (kg)',
                          hint: 'ex: 72.5',
                          controller: _wCtrl,
                          icon: Icons.monitor_weight_outlined,
                        ),
                        const SizedBox(height: 10),
                        _buildInputField(
                          label: 'Taille (m)',
                          hint: 'ex: 1.75',
                          controller: _hCtrl,
                          icon: Icons.height,
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _calc,
                            icon: const Icon(Icons.calculate_rounded, size: 22),
                            label: const Text("Calculer l'IMC"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildBmiCard(context),
                _buildLegend(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
