import 'package:flutter/material.dart';
import '../data/frases_db.dart';
import '../models/frase.dart';

class FormularioScreen extends StatefulWidget {
  final Frase? frase; // null = nueva, con valor = editar
  const FormularioScreen({super.key, this.frase});

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fraseCtrl;
  late final TextEditingController _autorCtrl;

  bool get _esEdicion => widget.frase != null;

  @override
  void initState() {
    super.initState();
    _fraseCtrl = TextEditingController(text: widget.frase?.frase ?? '');
    _autorCtrl = TextEditingController(text: widget.frase?.autor ?? '');
  }

  @override
  void dispose() {
    _fraseCtrl.dispose();
    _autorCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final frase = Frase(
      id: widget.frase?.id,
      frase: _fraseCtrl.text.trim(),
      autor: _autorCtrl.text.trim(),
    );

    if (_esEdicion) {
      await FrasesDb.instancia.actualizarFrase(frase);
    } else {
      await FrasesDb.instancia.insertarFrase(frase);
    }

    if (!mounted) return;
    Navigator.pop(context, true); // Avisa que hubo cambios
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar frase' : 'Nueva frase'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _fraseCtrl,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Frase',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.format_quote),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().length < 3) {
                  return 'Escribe al menos 3 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _autorCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Autor',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Escribe el autor';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _guardar,
              icon: const Icon(Icons.save),
              label: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}