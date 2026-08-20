/// Reporte de que catalogos llegaron (y cuantos registros trajo cada uno)
/// en la ultima corrida de CLI547_AGM_MOBILE_MASTER_SYNC. Se muestra en la
/// pestana Perfil para validar visualmente, sin necesidad de logs, que el
/// SP maestro esta devolviendo todos sus result sets.
class CatalogDiagnostic {
  const CatalogDiagnostic({required this.label, required this.count});

  final String label;
  final int count;

  bool get loaded => count > 0;

  Map<String, Object?> toJson() => {'label': label, 'count': count};

  factory CatalogDiagnostic.fromJson(Map<String, dynamic> json) => CatalogDiagnostic(
        label: json['label'] as String,
        count: json['count'] as int? ?? 0,
      );
}
