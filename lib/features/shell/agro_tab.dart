import 'package:flutter/material.dart';

enum AgroTab {
  inicio(Icons.home_rounded, 'Inicio'),
  tareo(Icons.task_alt_rounded, 'Tareo'),
  mapa(Icons.map_rounded, 'Mapa'),
  historial(Icons.history_rounded, 'Historial'),
  perfil(Icons.person_rounded, 'Perfil');

  const AgroTab(this.icon, this.label);

  final IconData icon;
  final String label;
}
