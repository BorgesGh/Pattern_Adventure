import 'package:flutter/material.dart';

class DialogArrasto extends StatefulWidget {
  final List<Widget> imagens;
  final List<int> ordemCorreta;
  final void Function(bool acertou) onRespondido;

  const DialogArrasto({
    super.key,
    required this.imagens,
    required this.ordemCorreta,
    required this.onRespondido,
  });

  @override
  State<DialogArrasto> createState() => _DialogArrastoState();
}

class _DialogArrastoState extends State<DialogArrasto> {
  final Map<int, int?> _alvos = {};
  final Map<int, bool> _ocupado = {};
  bool _mostrarResultado = false;
  bool _acertou = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.imagens.length; i++) {
      _alvos[i] = null;
      _ocupado[i] = false;
    }
  }

  void _verificarResposta() {
    bool acertou = true;
    for (int i = 0; i < widget.ordemCorreta.length; i++) {
      if (_alvos[i] != widget.ordemCorreta[i]) {
        acertou = false;
        break;
      }
    }

    setState(() {
      _mostrarResultado = true;
      _acertou = acertou;
    });
  }

  void _finalizarDialog() {
    Navigator.of(context).pop();
    widget.onRespondido(_acertou);
  }

  void _mostrarImagemAmpliada(Widget imagem) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(12),
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: InteractiveViewer(
                child: Center(child: imagem),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraggable(int index) {
    final imagem = widget.imagens[index];

    return GestureDetector(
      onTap: () => _mostrarImagemAmpliada(imagem),
      child: !_ocupado[index]!
          ? Draggable<int>(
        data: index,
        feedback: Opacity(opacity: 0.8, child: imagem),
        childWhenDragging: const SizedBox.shrink(),
        child: imagem,
      )
          : const SizedBox(width: 100, height: 100),
    );
  }

  Widget _buildDragTarget(int index) {
    return DragTarget<int>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: _mostrarResultado
                  ? (_alvos[index] == widget.ordemCorreta[index]
                  ? Colors.green
                  : Colors.red)
                  : Colors.blueGrey,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
            color: _alvos[index] != null ? Colors.grey.shade200 : Colors.white,
          ),
          child: _alvos[index] != null
              ? widget.imagens[_alvos[index]!]
              : _mostrarResultado && !_acertou
              ? widget.imagens[widget.ordemCorreta[index]]
              : const Center(child: Text("Arraste aqui")),
        );
      },
      onAccept: (data) {
        if (_mostrarResultado) return;

        setState(() {
          if (_alvos.values.contains(data)) {
            final oldKey = _alvos.entries.firstWhere((e) => e.value == data).key;
            _alvos[oldKey] = null;
            _ocupado[data] = false;
          }
          _alvos[index] = data;
          _ocupado[data] = true;
        });
      },
    );
  }

  Widget _buildConteudoJogo() {
    final draggableItems = List.generate(widget.imagens.length, _buildDraggable);
    final targets = List.generate(widget.imagens.length, _buildDragTarget);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Arraste cada imagem para o local correto:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: draggableItems,
        ),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: targets,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _alvos.values.any((element) => element == null) || _mostrarResultado
              ? null
              : _verificarResposta,
          child: const Text("Verificar"),
        ),
      ],
    );
  }

  Widget _buildResultado() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _acertou ? Icons.check_circle : Icons.error,
          color: _acertou ? Colors.green : Colors.red,
          size: 60,
        ),
        const SizedBox(height: 20),
        Text(
          _acertou ? 'Resposta Correta!' : 'Resposta Incorreta',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _acertou ? Colors.green : Colors.red,
          ),
        ),
        const SizedBox(height: 20),
        if (!_acertou) ...[
          const Text(
            'A ordem correta seria:',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: widget.ordemCorreta.map((index) => widget.imagens[index]).toList(),
          ),
          const SizedBox(height: 20),
        ],
        ElevatedButton(
          onPressed: _finalizarDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: _acertou ? Colors.green : Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Continuar'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = MediaQuery.of(context).size.height * 0.9;
        final maxWidth = MediaQuery.of(context).size.width * 0.9;

        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxHeight,
              maxWidth: maxWidth,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _mostrarResultado ? _buildResultado() : _buildConteudoJogo(),
            ),
          ),
        );
      },
    );
  }
}