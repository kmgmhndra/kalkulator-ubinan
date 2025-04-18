import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final TextEditingController _luasLahanController = TextEditingController();
  final TextEditingController _dataUbinanController = TextEditingController();

  double produktivitasGKP = 0;
  double produktivitasGKG = 0;
  double produktivitasBeras = 0;

  double produksiGKP = 0;
  double produksiGKG = 0;
  double produksiBeras = 0;

  void hitung() {
    final double? luasLahan = double.tryParse(_luasLahanController.text);
    final double? dataUbinan = double.tryParse(_dataUbinanController.text);

    if (luasLahan == null || dataUbinan == null) return;

    setState(() {
      produktivitasGKP = dataUbinan * 16;
      produktivitasGKG = produktivitasGKP * 0.8456;
      produktivitasBeras = produktivitasGKG * 0.6261;

      produksiGKP = (produktivitasGKP * luasLahan) / 10;
      produksiGKG = (produktivitasGKG * luasLahan) / 10;
      produksiBeras = (produktivitasBeras * luasLahan) / 10;
    });
  }

  void reset() {
    setState(() {
      _luasLahanController.clear();
      _dataUbinanController.clear();
      produktivitasGKP = 0;
      produktivitasGKG = 0;
      produktivitasBeras = 0;
      produksiGKP = 0;
      produksiGKG = 0;
      produksiBeras = 0;
    });
  }

  Widget buildCard(
    String title,
    double gkp,
    double gkg,
    double beras,
    String unit,
  ) {
    String hasil =
        "GKP: ${gkp.toStringAsFixed(2)} $unit\n"
        "GKG: ${gkg.toStringAsFixed(2)} $unit\n"
        "Beras: ${beras.toStringAsFixed(2)} $unit";

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 12),
            Text(hasil),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.copy, color: Colors.grey),
                tooltip: "Salin Hasil",
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: hasil));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Hasil disalin!")),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Ubinan Padi'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo1.png', height: 70),
                const SizedBox(width: 16),
                Image.asset('assets/logo2.png', height: 70),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _luasLahanController,
              decoration: const InputDecoration(
                labelText: 'Luas Lahan (hektar)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _dataUbinanController,
              decoration: const InputDecoration(
                labelText: 'Data Ubinan',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text(
                      "Reset",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: reset,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calculate, color: Colors.white),
                    label: const Text(
                      "Hitung",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: hitung,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            buildCard(
              "PRODUKTIVITAS (Kwintal/Hektar)",
              produktivitasGKP,
              produktivitasGKG,
              produktivitasBeras,
              "Kw/Ha",
            ),
            buildCard(
              "PRODUKSI (Ton)",
              produksiGKP,
              produksiGKG,
              produksiBeras,
              "Ton",
            ),
          ],
        ),
      ),
    );
  }
}
