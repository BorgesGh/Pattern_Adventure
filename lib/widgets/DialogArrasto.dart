import 'package:flutter/material.dart';
import '../domain/PerguntaArrasto.dart';

class DialogArrasto extends StatefulWidget {
  final PerguntaArrasto pergunta;
  final void Function(bool acertou) onRespondido;

  const DialogArrasto({
    super.key,
    required this.pergunta,
    required this.onRespondido,
  });

  @override
  State<DialogArrasto> createState() => _DialogArrastoState();
}

class _DialogArrastoState extends State<DialogArrasto> {
  final Map<int, int?> _alvos = {};
  final Map<int, bool> _imagemDisponivel = {};
  bool _mostrarResultado = false;
  bool _acertou = false;
  int? _imagemExpandidaIndex;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.pergunta.caminhosImagens.length; i++) {
      _alvos[i] = null;
      _imagemDisponivel[i] = true; // Todas as imagens começam disponíveis
    }
  }

  void _verificarResposta() {
    bool acertou = true;
    for (int i = 0; i < widget.pergunta.ordemCorreta.length; i++) {
      if (_alvos[i] != widget.pergunta.ordemCorreta[i]) {
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

  void _expandirImagem(int index) {
    setState(() {
      _imagemExpandidaIndex = index;
    });
  }

  void _retrairImagem() {
    setState(() {
      _imagemExpandidaIndex = null;
    });
  }

  Widget _buildDraggable(int index) {
    if (!_imagemDisponivel[index]!) {
      return const SizedBox.shrink(); // Não mostra imagens já colocadas nos alvos
    }

    final imagePath = widget.pergunta.caminhosImagens[index];

    return GestureDetector(
      onTap: () => _expandirImagem(index),
      child: Draggable<int>(
        data: index,
        feedback: Opacity(
          opacity: 0.8,
          child: Image.asset(imagePath, width: 100, height: 100),
        ),
        childWhenDragging: const SizedBox.shrink(),
        child: Image.asset(imagePath, width: 100, height: 100),
      ),
    );
  }

  Widget _buildDragTarget(int index) {
    return DragTarget<int>(
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: _alvos[index] != null
              ? () => _expandirImagem(_alvos[index]!)
              : null,
          child: Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: _mostrarResultado
                    ? (_alvos[index] == widget.pergunta.ordemCorreta[index]
                    ? Colors.green
                    : Colors.red)
                    : Colors.blueGrey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
              color: _alvos[index] != null ? Colors.grey.shade200 : Colors.white,
            ),
            child: _alvos[index] != null
                ? Image.asset(
              widget.pergunta.caminhosImagens[_alvos[index]!],
              width: 100,
              height: 100,
            )
                : _mostrarResultado && !_acertou
                ? Image.asset(
              widget.pergunta.caminhosImagens[widget.pergunta.ordemCorreta[index]],
              width: 100,
              height: 100,
            )
                : Center(
              child: Text(
                widget.pergunta.alternativas[widget.pergunta.ordemCorreta[index]],
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
      onAcceptWithDetails: (details) {
        if (_mostrarResultado) return;

        setState(() {
          // Remove a imagem do alvo anterior se ela estava em outro lugar
          for (var entry in _alvos.entries) {
            if (entry.value == details.data) {
              _alvos[entry.key] = null;
              _imagemDisponivel[details.data] = true;
              break;
            }
          }

          // Adiciona a imagem ao novo alvo
          _alvos[index] = details.data;
          _imagemDisponivel[details.data] = false;
        });
      },
    );
  }

  Widget _buildImagemExpandida() {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: Image.asset(
                widget.pergunta.caminhosImagens[_imagemExpandidaIndex!],
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: _retrairImagem,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConteudoJogo() {
    final draggableItems = List.generate(widget.pergunta.caminhosImagens.length, _buildDraggable);
    final targets = List.generate(widget.pergunta.caminhosImagens.length, _buildDragTarget);

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
            children: widget.pergunta.ordemCorreta
                .map((index) => GestureDetector(
              onTap: () => _expandirImagem(index),
              child: Image.asset(
                widget.pergunta.caminhosImagens[index],
                width: 100,
                height: 100,
              ),
            ))
                .toList(),
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
    if (_imagemExpandidaIndex != null) {
      return _buildImagemExpandida();
    }

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