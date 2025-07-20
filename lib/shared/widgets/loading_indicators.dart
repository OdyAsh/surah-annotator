import 'package:flutter/material.dart';

class AppLoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;

  const AppLoadingIndicator({
    super.key,
    this.message,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: const CircularProgressIndicator(),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

class AppLinearProgressIndicator extends StatelessWidget {
  final double? value;
  final String? label;
  final Color? backgroundColor;
  final Color? valueColor;

  const AppLinearProgressIndicator({
    super.key,
    this.value,
    this.label,
    this.backgroundColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
        ],
        LinearProgressIndicator(
          value: value,
          backgroundColor: backgroundColor,
          valueColor: valueColor != null
              ? AlwaysStoppedAnimation<Color>(valueColor!)
              : null,
        ),
        if (value != null) ...[
          const SizedBox(height: 4),
          Text(
            '${(value! * 100).toStringAsFixed(0)}%',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}

class AppCircularProgressIndicator extends StatelessWidget {
  final double? value;
  final String? label;
  final double size;
  final Color? backgroundColor;
  final Color? valueColor;
  final double strokeWidth;

  const AppCircularProgressIndicator({
    super.key,
    this.value,
    this.label,
    this.size = 60.0,
    this.backgroundColor,
    this.valueColor,
    this.strokeWidth = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: value,
                backgroundColor: backgroundColor,
                valueColor: valueColor != null
                    ? AlwaysStoppedAnimation<Color>(valueColor!)
                    : null,
                strokeWidth: strokeWidth,
              ),
              if (value != null)
                Text(
                  '${(value! * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
            ],
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 8),
          Text(
            label!,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

class WaveformLoadingIndicator extends StatefulWidget {
  final double height;
  final Color? color;

  const WaveformLoadingIndicator({
    super.key,
    this.height = 60.0,
    this.color,
  });

  @override
  State<WaveformLoadingIndicator> createState() => _WaveformLoadingIndicatorState();
}

class _WaveformLoadingIndicatorState extends State<WaveformLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    
    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(20, (index) {
              final progress = (_animation.value + (index * 0.1)) % 1.0;
              final height = widget.height * (0.3 + 0.7 * progress);
              
              return Container(
                width: 3,
                height: height,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.3 + 0.7 * progress),
                  borderRadius: BorderRadius.circular(1.5),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
