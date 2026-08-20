import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

/// Banner persistente que avisa cuando el dispositivo esta sin conexion.
/// Los tareos siguen guardandose localmente (outbox) y se envian al volver
/// a tener red.
class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        final results = snapshot.data;
        final offline = results != null && results.every((r) => r == ConnectivityResult.none);
        if (!offline) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          color: const Color(0xFFBA1A1A),
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off_rounded, color: Colors.white, size: 16),
              SizedBox(width: 6),
              Text(
                'Sin conexion — los tareos se guardan localmente',
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      },
    );
  }
}
