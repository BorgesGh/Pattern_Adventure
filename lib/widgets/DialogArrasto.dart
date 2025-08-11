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

  // NOVO: listas de ordem visual (contêm índices originais das imagens/caixas)
  late List<int> _draggableOrder;
  late List<int> _targetOrder;

  @override
  void initState() {
    super.initState();
    final n = widget.pergunta.caminhosImagens.length;

    // inicializa alvos/ disponibilidade (chaves são índices visuais dos alvos)
    for (int i = 0; i < n; i++) {
      _alvos[i] = null;
      _imagemDisponivel[i] = true;
    }

    // cria e embaralha as ordens visuais (mantendo índices originais)
    _draggableOrder = List.generate(n, (i) => i)..shuffle();
    _targetOrder = List.generate(n, (i) => i)..shuffle();
  }

  void _verificarResposta() {
    bool acertou = true;
    for (int visualIndex = 0; visualIndex < _targetOrder.length; visualIndex++) {
      final originalTargetIndex = _targetOrder[visualIndex];
      final expectedImageIndex = widget.pergunta.ordemCorreta[originalTargetIndex];
      if (_alvos[visualIndex] != expectedImageIndex) {
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

  // Agora recebe imageIndex (índice original da imagem)
  Widget _buildDraggable(int imageIndex) {
    if (!_imagemDisponivel[imageIndex]!) {
      return const SizedBox.shrink();
    }

    final imagePath = widget.pergunta.caminhosImagens[imageIndex];

    return GestureDetector(
      onTap: () => _expandirImagem(imageIndex),
      child: Draggable<int>(
        data: imageIndex,
        feedback: Opacity(
          opacity: 0.8,
          child: Image.asset(imagePath, width: 100, height: 100),
        ),
        childWhenDragging: const SizedBox.shrink(),
        child: Image.asset(imagePath, width: 100, height: 100),
      ),
    );
  }

  // index é o índice visual do alvo; mapeamos para originalTargetIndex
  Widget _buildDragTarget(int visualIndex) {
    final originalTargetIndex = _targetOrder[visualIndex];

    return DragTarget<int>(
      builder: (context, candidateData, rejectedData) {
        // se o alvo visual contém uma imagem, _alvos[visualIndex] será o índice original da imagem
        final placedImageIndex = _alvos[visualIndex];
        final expectedImageIndex = widget.pergunta.ordemCorreta[originalTargetIndex];

        return GestureDetector(
          onTap: placedImageIndex != null ? () => _expandirImagem(placedImageIndex) : null,
          child: Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: _mostrarResultado
                    ? (placedImageIndex == expectedImageIndex ? Colors.green : Colors.red)
                    : Colors.blueGrey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
              color: placedImageIndex != null ? Colors.grey.shade200 : Colors.white,
            ),
            child: placedImageIndex != null
                ? Image.asset(
              widget.pergunta.caminhosImagens[placedImageIndex],
              width: 100,
              height: 100,
            )
                : _mostrarResultado && !_acertou
                ? GestureDetector(
              onTap: () => _expandirImagem(expectedImageIndex),
              child: Image.asset(
                widget.pergunta.caminhosImagens[expectedImageIndex],
                width: 100,
                height: 100,
              ),
            )
                : Center(
              child: Text(
                // mostra o nome (alternativa) esperada para este alvo
                widget.pergunta.alternativas[expectedImageIndex],
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
      onAcceptWithDetails: (details) {
        if (_mostrarResultado) return;

        setState(() {
          // remove a imagem do alvo anterior (se já estava em outro)
          for (var entry in _alvos.entries) {
            if (entry.value == details.data) {
              _alvos[entry.key] = null;
              _imagemDisponivel[details.data] = true;
              break;
            }
          }

          // coloca a imagem no alvo visual atual (visualIndex)
          _alvos[visualIndex] = details.data;
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
    // cria widgets de draggable na ordem embaralhada
    final draggableItems = _draggableOrder.map((imgIdx) => _buildDraggable(imgIdx)).toList();
    final targets = List.generate(widget.pergunta.caminhosImagens.length, (i) => _buildDragTarget(i));

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
            // mostra a sequência correta (usa ordemCorreta do modelo)
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
