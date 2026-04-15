import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class SunTimesCard extends StatelessWidget {
  final WeatherData weather;

  const SunTimesCard({super.key, required this.weather});

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  double _getSunProgress() {
    final now = DateTime.now();
    if (now.isBefore(weather.sunrise)) return 0;
    if (now.isAfter(weather.sunset)) return 1;
    final total = weather.sunset.difference(weather.sunrise).inMinutes;
    final elapsed = now.difference(weather.sunrise).inMinutes;
    return elapsed / total;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _getSunProgress();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sun Times',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _SunTimeItem(
                icon: Icons.wb_twilight,
                label: 'Sunrise',
                time: _formatTime(weather.sunrise),
                color: const Color(0xFFFFCA28),
              ),
              Expanded(
                child: _SunArcPainter(progress: progress),
              ),
              _SunTimeItem(
                icon: Icons.nightlight_round,
                label: 'Sunset',
                time: _formatTime(weather.sunset),
                color: const Color(0xFFFF7043),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFCA28)),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _SunTimeItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;
  final Color color;

  const _SunTimeItem({
    required this.icon,
    required this.label,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _SunArcPainter extends StatelessWidget {
  final double progress;

  const _SunArcPainter({required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: CustomPaint(
        painter: _ArcPainterCustom(progress: progress),
      ),
    );
  }
}

class _ArcPainterCustom extends CustomPainter {
  final double progress;

  _ArcPainterCustom({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    final rect = Rect.fromLTRB(0, 10, size.width, size.height * 2);
    path.addArc(rect, 3.14159, 3.14159);
    canvas.drawPath(path, paint);

    // Sun position
    if (progress > 0 && progress < 1) {
      final angle = 3.14159 + progress * 3.14159;
      final cx = size.width / 2;
      final cy = size.height;
      final rx = size.width / 2;
      final ry = size.height;
      final sunX = cx + rx * (progress - 0.5) * 2;
      final sunY = cy - ry * (1 - (2 * progress - 1).abs());

      final sunPaint = Paint()
        ..color = const Color(0xFFFFCA28)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(sunX, sunY), 8, sunPaint);
      canvas.drawCircle(
        Offset(sunX, sunY),
        12,
        Paint()
          ..color = const Color(0xFFFFCA28).withOpacity(0.3)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(_ArcPainterCustom oldDelegate) =>
      oldDelegate.progress != progress;
}
