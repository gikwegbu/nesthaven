import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchDisclaimerWrapper extends StatefulWidget {
  final Widget child;

  const LaunchDisclaimerWrapper({super.key, required this.child});

  @override
  State<LaunchDisclaimerWrapper> createState() =>
      _LaunchDisclaimerWrapperState();
}

class _LaunchDisclaimerWrapperState extends State<LaunchDisclaimerWrapper> {
  bool _acknowledged = false;

  @override
  void initState() {
    super.initState();
    // No longer using showDialog here as it requires a Navigator
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          widget.child,
          if (!_acknowledged) ...[
            // Full-screen blocker
            ModalBarrier(
              dismissible: false,
              color: Colors.black.withValues(alpha: 0.7),
            ),
            // Disclaimer Content
            Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 48,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Important Notice',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Flexible(
                      child: SingleChildScrollView(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      height: 1.5,
                                    ),
                            children: [
                              const TextSpan(
                                text: 'Welcome to NestHaven!\n\n',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const TextSpan(
                                text:
                                    'Please note that this is a purely personal portfolio application. All property listings, agent details, pricing, and any other information displayed within this app are entirely fictional and created solely for demonstration purposes.\n\n',
                              ),
                              const TextSpan(
                                text:
                                    'All images used throughout the app are sourced from ',
                              ),
                              TextSpan(
                                text: 'Unsplash.com',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _launchUrl('https://unsplash.com');
                                  },
                              ),
                              const TextSpan(
                                text:
                                    ' and are used in accordance with the Unsplash licence.\n\n',
                              ),
                              const TextSpan(
                                text:
                                    'By tapping \'I Understand & Continue\', you acknowledge that this app is a portfolio project and that no real transactions, bookings, or communications will take place.',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          setState(() {
                            _acknowledged = true;
                          });
                        },
                        child: const Text(
                          'I Understand & Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
