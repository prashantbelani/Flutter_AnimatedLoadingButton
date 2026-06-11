class AnimatedLoadingButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;

  const AnimatedLoadingButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
  });

  @override
  State<AnimatedLoadingButton> createState() => _AnimatedLoadingButtonState();
}

class _AnimatedLoadingButtonState extends State<AnimatedLoadingButton> {
  bool _isLoading = false;
  bool _isSuccess = false;
  double _scale = 1.0;

  Future<void> _handleTap() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    widget.onPressed?.call();

    // Simulate API time
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSuccess = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isSuccess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onTapDown: (_) {
        if (!_isLoading) {
          setState(() => _scale = 0.95);
        }
      },
      onTapUp: (_) {
        if (!_isLoading) {
          setState(() => _scale = 1.0);
        }
      },
      onTapCancel: () {
        if (!_isLoading) {
          setState(() => _scale = 1.0);
        }
      },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          width: (_isLoading || _isSuccess) ? 56 : 220,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              (_isLoading || _isSuccess) ? 28 : 14,
            ),
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: _isSuccess
                  ? const Icon(
                      Icons.check,
                      key: ValueKey("success"),
                      color: Colors.white,
                      size: 28,
                    )
                  : _isLoading
                  ? const SizedBox(
                      key: ValueKey("loader"),
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : FittedBox(
                      key: const ValueKey("button"),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(widget.icon, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            widget.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
