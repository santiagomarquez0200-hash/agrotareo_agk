import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

/// Sesion del usuario autenticado + identificador estable del dispositivo.
///
/// No se guarda la contrasena. Los datos de perfil vienen de
/// `CLI547_AGMSP_AGK_GetUserContext` (sede, fundo, puesto, DNI) y, como
/// respaldo, de `Accounts_userprofile` dentro del sync maestro.
class SessionUser {
  const SessionUser({
    required this.username,
    this.userProfileId,
    this.employeeId,
    this.personId,
    this.nombre,
    this.groupId,
    this.dni,
    this.puestoTrabajo,
    this.sede,
    this.idSede,
    this.centroAgrotareo,
    this.fundo,
    this.idFundo,
    this.estado,
  });

  final String username;
  final int? userProfileId;
  final int? employeeId;
  final int? personId;
  final String? nombre;
  final int? groupId;
  final String? dni;
  final String? puestoTrabajo;
  final String? sede;
  final int? idSede;
  final int? centroAgrotareo;
  final String? fundo;
  final int? idFundo;
  final String? estado;

  String get displayName => (nombre == null || nombre!.trim().isEmpty) ? username : nombre!;

  String get initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    return parts.take(2).map((p) => p[0]).join().toUpperCase();
  }

  Map<String, Object?> toJson() => {
        'username': username,
        'userProfileId': userProfileId,
        'employeeId': employeeId,
        'personId': personId,
        'nombre': nombre,
        'groupId': groupId,
        'dni': dni,
        'puestoTrabajo': puestoTrabajo,
        'sede': sede,
        'idSede': idSede,
        'centroAgrotareo': centroAgrotareo,
        'fundo': fundo,
        'idFundo': idFundo,
        'estado': estado,
      };

  factory SessionUser.fromJson(Map<String, dynamic> json) => SessionUser(
        username: json['username'] as String,
        userProfileId: json['userProfileId'] as int?,
        employeeId: json['employeeId'] as int?,
        personId: json['personId'] as int?,
        nombre: json['nombre'] as String?,
        groupId: json['groupId'] as int?,
        dni: json['dni'] as String?,
        puestoTrabajo: json['puestoTrabajo'] as String?,
        sede: json['sede'] as String?,
        idSede: json['idSede'] as int?,
        centroAgrotareo: json['centroAgrotareo'] as int?,
        fundo: json['fundo'] as String?,
        idFundo: json['idFundo'] as int?,
        estado: json['estado'] as String?,
      );
}

class SessionStorage {
  SessionStorage._();

  static const _userKey = 'agrotareo_session_user';
  static const _deviceIdKey = 'agrotareo_device_id';

  static const _storage = FlutterSecureStorage();

  static Future<void> saveUser(SessionUser user) async {
    await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
  }

  static Future<SessionUser?> getUser() async {
    final raw = await _storage.read(key: _userKey);
    if (raw == null) return null;
    try {
      return SessionUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear() async {
    await _storage.delete(key: _userKey);
  }

  static Future<String> deviceId() async {
    final cached = await _storage.read(key: _deviceIdKey);
    if (cached != null && cached.isNotEmpty) return cached;
    final id = 'AGK-${const Uuid().v4().substring(0, 8).toUpperCase()}';
    await _storage.write(key: _deviceIdKey, value: id);
    return id;
  }
}
