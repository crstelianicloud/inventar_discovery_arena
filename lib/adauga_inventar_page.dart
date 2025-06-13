import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdaugaInventarPage extends StatefulWidget {
  @override
  _AdaugaInventarPageState createState() => _AdaugaInventarPageState();
}

class _AdaugaInventarPageState extends State<AdaugaInventarPage> {
  final _formKey = GlobalKey<FormState>();
  final _produsController = TextEditingController();
  final _cantitateController = TextEditingController();
  final _pretController = TextEditingController();

  Map<String, dynamic> _produse = {};

  String getDataZilei() {
    return DateTime.now().toIso8601String().substring(0, 10);
  }

  Future<void> salveazaInventar() async {
    String dataZilei = getDataZilei();

    String numeProdus = _produsController.text.trim();
    String cantitateStr = _cantitateController.text.trim();
    String pretStr = _pretController.text.trim();

    // Conversie sigură și verificări
    int? cantitate = int.tryParse(cantitateStr);
    double? pret = double.tryParse(pretStr);

    if (numeProdus.isNotEmpty && cantitate != null && cantitate > 0 && pret != null && pret >= 0) {
      _produse[numeProdus] = {
        'cantitate': cantitate,
        'pret': pret,
      };

      try {
        await FirebaseFirestore.instance.collection('inventare').doc(dataZilei).set({
          'data': dataZilei,
          'produse': _produse,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Inventar salvat pentru data $dataZilei')),
        );
        // Goleste formularul după salvare
        _produsController.clear();
        _cantitateController.clear();
        _pretController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Eroare la salvare: $e')),
        );
      }
    } else {
      // Mesaj de eroare dacă câmpurile nu sunt completate corect
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Completează toate câmpurile corect')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adaugă inventar pentru azi'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _produsController,
              decoration: InputDecoration(labelText: 'Nume produs'),
            ),
            TextField(
              controller: _cantitateController,
              decoration: InputDecoration(labelText: 'Cantitate'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _pretController,
              decoration: InputDecoration(labelText: 'Preț'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Salvează inventarul zilei'),
              onPressed: salveazaInventar,
            ),
          ],
        ),
      ),
    );
  }
}