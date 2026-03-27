import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:vibration/vibration.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage>
    with SingleTickerProviderStateMixin {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: false,
  );
  bool _isScanned = false;

  late final AnimationController _scanLineController;

  @override
  void initState() {
    super.initState();
    _scanLineController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isScanned) return;
    final List<Barcode> barcodes = capture.barcodes;

    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        _isScanned = true;
        // Vibrate
        final hasVibrator = await Vibration.hasVibrator();
        if (hasVibrator == true) {
          Vibration.vibrate(duration: 80);
        }

        if (mounted) {
          context.pop(barcode.rawValue);
        }
        break; // Only take first one
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const double boxW = 260;
    const double boxH = 180;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Scan Barcode',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          // Camera feed
          MobileScanner(
            controller: controller,
            onDetect: _onDetect,
          ),

          // Scrim with transparent cutout
          IgnorePointer(
            child: CustomPaint(
              painter: _ScannerOverlayPainter(
                  boxWidth: boxW, boxHeight: boxH),
              child: const SizedBox.expand(),
            ),
          ),

          // Scan box: corners + animated scan line
          Center(
            child: SizedBox(
              width: boxW,
              height: boxH,
              child: Stack(
                children: [
                  // Corner brackets
                  ...[
                    Alignment.topLeft,
                    Alignment.topRight,
                    Alignment.bottomLeft,
                    Alignment.bottomRight,
                  ].map((a) => _buildCorner(a)),

                  // Animated scan line
                  AnimatedBuilder(
                    animation: _scanLineController,
                    builder: (context, _) {
                      return Positioned(
                        top: _scanLineController.value * (boxH - 4),
                        left: 12,
                        right: 12,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.greenAccent.withValues(alpha: 0.9),
                                Colors.transparent,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.greenAccent
                                    .withValues(alpha: 0.5),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Instruction label
          const Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Text(
              'Align barcode within the frame',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  letterSpacing: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: SizedBox(
        width: 28,
        height: 28,
        child: CustomPaint(
          painter: _CornerPainter(
            alignment: alignment,
            color: Colors.greenAccent,
            thickness: 3.5,
          ),
        ),
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final double boxWidth;
  final double boxHeight;

  const _ScannerOverlayPainter(
      {required this.boxWidth, required this.boxHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final scrimPaint = Paint()..color = Colors.black.withValues(alpha: 0.6);
    final cx = size.width / 2;
    final cy = size.height / 2;
    final rect = Rect.fromCenter(
        center: Offset(cx, cy), width: boxWidth, height: boxHeight);

    final fullPath = Path()..addRect(Offset.zero & size);
    final cutout = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)));
    final combined =
        Path.combine(PathOperation.difference, fullPath, cutout);
    canvas.drawPath(combined, scrimPaint);
  }

  @override
  bool shouldRepaint(_ScannerOverlayPainter old) =>
      old.boxWidth != boxWidth || old.boxHeight != boxHeight;
}

class _CornerPainter extends CustomPainter {
  final Alignment alignment;
  final Color color;
  final double thickness;

  const _CornerPainter(
      {required this.alignment,
      required this.color,
      required this.thickness});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double len = size.width * 0.7;
    final bool isLeft = alignment == Alignment.topLeft ||
        alignment == Alignment.bottomLeft;
    final bool isTop =
        alignment == Alignment.topLeft || alignment == Alignment.topRight;

    final double x0 = isLeft ? 0 : size.width;
    final double y0 = isTop ? 0 : size.height;
    final double x1 = isLeft ? len : size.width - len;
    final double y1 = isTop ? len : size.height - len;

    canvas.drawLine(Offset(x0, y0), Offset(x1, y0), paint);
    canvas.drawLine(Offset(x0, y0), Offset(x0, y1), paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) =>
      old.alignment != alignment ||
      old.color != color ||
      old.thickness != thickness;
}
