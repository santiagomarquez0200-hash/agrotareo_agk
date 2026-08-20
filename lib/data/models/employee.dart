class Employee {
  const Employee({
    required this.id,
    required this.codigoTrabajador,
    this.locationId,
    this.nombre,
    this.documento,
    required this.activo,
  });

  final int id;
  final String codigoTrabajador;
  final int? locationId;
  final String? nombre;
  final String? documento;
  final bool activo;

  String get displayName => (nombre == null || nombre!.trim().isEmpty) ? codigoTrabajador : nombre!;

  Map<String, dynamic> toRow() => {
        'Employee_Id': id,
        'CodigoTrabajador': codigoTrabajador,
        'Ubicacion_Id': locationId,
        'Nombre': nombre,
        'Documento': documento,
        'Activo': activo,
      };

  factory Employee.fromRow(Map<String, dynamic> row) {
    final nombre = row['Nombre'];
    final segundo = row['SegundoNombre'];
    final apellidos = row['Apellidos'];
    final fullName = [nombre, segundo, apellidos]
        .whereType<String>()
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .join(' ');
    return Employee(
      id: _toInt(row['Employee_Id']) ?? 0,
      codigoTrabajador: (row['CodigoTrabajador'] ?? '').toString(),
      locationId: _toInt(row['Ubicacion_Id']),
      nombre: fullName.isEmpty ? null : fullName,
      documento: row['Documento']?.toString(),
      activo: _toBool(row['Activo']),
    );
  }
}

class ProductivityTypeCatalog {
  const ProductivityTypeCatalog({
    required this.id,
    required this.nombre,
    this.modoLectura,
    this.valorDefecto,
    this.minimo,
    this.maximo,
    this.incremento,
    this.puedeRepetir = true,
    this.visibleEnApp = true,
  });

  final int id;
  final String nombre;
  final String? modoLectura;
  final double? valorDefecto;
  final double? minimo;
  final double? maximo;
  final double? incremento;
  final bool puedeRepetir;
  final bool visibleEnApp;

  /// Valida una cantidad contra el rango [minimo, maximo] del tipo de
  /// productividad (segun la especificacion funcional). Si no hay rango
  /// definido en el catalogo, no se restringe.
  String? validar(double cantidad) {
    if (minimo != null && cantidad < minimo!) {
      return 'Debe ser al menos ${_fmt(minimo!)}';
    }
    if (maximo != null && cantidad > maximo!) {
      return 'No puede superar ${_fmt(maximo!)}';
    }
    return null;
  }

  static String _fmt(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  Map<String, dynamic> toRow() => {
        'ProductivityType_Id': id,
        'ProductivityType_Nombre': nombre,
        'ModoLectura': modoLectura,
        'ValorDefecto': valorDefecto,
        'Minimo': minimo,
        'Maximo': maximo,
        'Incremento': incremento,
        'PuedeRepetir': puedeRepetir,
        'VisibleEnApp': visibleEnApp,
      };

  factory ProductivityTypeCatalog.fromRow(Map<String, dynamic> row) => ProductivityTypeCatalog(
        id: _toInt(row['ProductivityType_Id']) ?? 0,
        nombre: (row['ProductivityType_Nombre'] ?? '').toString(),
        modoLectura: row['ModoLectura']?.toString(),
        valorDefecto: _toDouble(row['ValorDefecto']),
        minimo: _toDouble(row['Minimo']),
        maximo: _toDouble(row['Maximo']),
        incremento: _toDouble(row['Incremento']),
        puedeRepetir: row.containsKey('PuedeRepetir') ? _toBool(row['PuedeRepetir']) : true,
        visibleEnApp: row.containsKey('VisibleEnApp') ? _toBool(row['VisibleEnApp']) : true,
      );
}

class ProductCatalog {
  const ProductCatalog({required this.id, required this.nombre, required this.codigo});

  final int id;
  final String nombre;
  final String codigo;

  Map<String, dynamic> toRow() => {'Product_Id': id, 'Product_Nombre': nombre, 'Product_Codigo': codigo};

  factory ProductCatalog.fromRow(Map<String, dynamic> row) => ProductCatalog(
        id: _toInt(row['Product_Id']) ?? 0,
        nombre: (row['Product_Nombre'] ?? '').toString(),
        codigo: (row['Product_Codigo'] ?? '').toString(),
      );
}

class LocationTypeCatalog {
  const LocationTypeCatalog({required this.id, required this.nombre, required this.codigo});

  final int id;
  final String nombre;
  final String codigo;

  Map<String, dynamic> toRow() => {'id': id, 'name': nombre, 'code': codigo};

  factory LocationTypeCatalog.fromRow(Map<String, dynamic> row) => LocationTypeCatalog(
        id: _toInt(row['id']) ?? 0,
        nombre: (row['name'] ?? '').toString(),
        codigo: (row['code'] ?? '').toString(),
      );
}

class SubgroupCatalog {
  const SubgroupCatalog({required this.id, required this.nombre, required this.codigo, this.groupId});

  final int id;
  final String nombre;
  final String codigo;
  final int? groupId;

  Map<String, dynamic> toRow() =>
      {'Subgrupo_Id': id, 'Subgrupo_Nombre': nombre, 'Subgrupo_Codigo': codigo, 'Grupo_Id': groupId};

  factory SubgroupCatalog.fromRow(Map<String, dynamic> row) => SubgroupCatalog(
        id: _toInt(row['Subgrupo_Id']) ?? 0,
        nombre: (row['Subgrupo_Nombre'] ?? '').toString(),
        codigo: (row['Subgrupo_Codigo'] ?? '').toString(),
        groupId: _toInt(row['Grupo_Id']),
      );
}

class VarietyCatalog {
  const VarietyCatalog({required this.id, required this.nombre, required this.codigo});

  final int id;
  final String nombre;
  final String codigo;

  Map<String, dynamic> toRow() => {'Variedad_Id': id, 'Variedad_Nombre': nombre, 'Variedad_Codigo': codigo};

  factory VarietyCatalog.fromRow(Map<String, dynamic> row) => VarietyCatalog(
        id: _toInt(row['Variedad_Id']) ?? 0,
        nombre: (row['Variedad_Nombre'] ?? '').toString(),
        codigo: (row['Variedad_Codigo'] ?? '').toString(),
      );
}

class BusinessUnitCatalog {
  const BusinessUnitCatalog({required this.id, required this.nombre, required this.codigo});

  final int id;
  final String nombre;
  final String codigo;

  Map<String, dynamic> toRow() =>
      {'BusinessUnit_Id': id, 'BusinessUnit_Nombre': nombre, 'BusinessUnit_Codigo': codigo};

  factory BusinessUnitCatalog.fromRow(Map<String, dynamic> row) => BusinessUnitCatalog(
        id: _toInt(row['BusinessUnit_Id']) ?? 0,
        nombre: (row['BusinessUnit_Nombre'] ?? '').toString(),
        codigo: (row['BusinessUnit_Codigo'] ?? '').toString(),
      );
}

class TaskOrderCatalog {
  const TaskOrderCatalog({required this.id, required this.codigo});

  final int id;
  final String codigo;

  Map<String, dynamic> toRow() => {'TaskOrder_Id': id, 'Codigo': codigo};

  factory TaskOrderCatalog.fromRow(Map<String, dynamic> row) => TaskOrderCatalog(
        id: _toInt(row['TaskOrder_Id']) ?? 0,
        codigo: (row['Codigo'] ?? '').toString(),
      );
}

/// Fila de `CLI547_AGMSP_AGK_GetUserContext`: contexto completo del usuario
/// autenticado (sede/fundo/lugar reales), usada para resolver los
/// parametros del sync maestro sin pedirlos manualmente.
class UserContext {
  const UserContext({
    required this.codigoUsuario,
    this.nombreCompleto,
    this.dni,
    this.puestoTrabajo,
    this.codigoTrabajador,
    this.sede,
    this.idSede,
    this.centroAgrotareo,
    this.userProfileId,
    this.employeeId,
    this.idWorkerErp,
    this.fundo,
    this.idFundo,
    this.estado,
  });

  final String codigoUsuario;
  final String? nombreCompleto;
  final String? dni;
  final String? puestoTrabajo;
  final String? codigoTrabajador;
  final String? sede;
  final int? idSede;
  final int? centroAgrotareo;
  final int? userProfileId;
  final int? employeeId;
  final int? idWorkerErp;
  final String? fundo;
  final int? idFundo;
  final String? estado;

  factory UserContext.fromRow(Map<String, dynamic> row) => UserContext(
        codigoUsuario: (row['CodigoUsuario'] ?? '').toString(),
        nombreCompleto: row['NombreCompleto']?.toString(),
        dni: row['DNI']?.toString(),
        puestoTrabajo: row['PuestoTrabajo']?.toString(),
        codigoTrabajador: row['CodigoTrabajador']?.toString(),
        sede: row['Sede']?.toString(),
        idSede: _toInt(row['IdSede']),
        centroAgrotareo: _toInt(row['CentroAgrotareo']),
        userProfileId: _toInt(row['UserProfileId']),
        employeeId: _toInt(row['EmployeeId']),
        idWorkerErp: _toInt(row['IdWorkerERP']),
        fundo: row['Fundo']?.toString(),
        idFundo: _toInt(row['IdFundo']),
        estado: row['EstadoDescripcion']?.toString(),
      );
}

class ActivityCatalog {
  const ActivityCatalog({
    required this.id,
    required this.codigo,
    required this.nombre,
    required this.productiva,
    required this.grupal,
    this.productoDefaultId,
  });

  final int id;
  final String codigo;
  final String nombre;
  final bool productiva;
  final bool grupal;
  final int? productoDefaultId;

  Map<String, dynamic> toRow() => {
        'Activity_Id': id,
        'Activity_Codigo': codigo,
        'Activity_Nombre': nombre,
        'EsProductiva': productiva,
        'EsGrupal': grupal,
        'ProductoDefault_Id': productoDefaultId,
      };

  factory ActivityCatalog.fromRow(Map<String, dynamic> row) => ActivityCatalog(
        id: _toInt(row['Activity_Id']) ?? 0,
        codigo: (row['Activity_Codigo'] ?? '').toString(),
        nombre: (row['Activity_Nombre'] ?? '').toString(),
        productiva: _toBool(row['EsProductiva']),
        grupal: _toBool(row['EsGrupal']),
        productoDefaultId: _toInt(row['ProductoDefault_Id']),
      );
}

class LocationCatalog {
  const LocationCatalog({
    required this.id,
    required this.nombre,
    required this.codigo,
    this.lat,
    this.long,
    this.parentId,
  });

  final int id;
  final String nombre;
  final String codigo;
  final double? lat;
  final double? long;
  final int? parentId;

  Map<String, dynamic> toRow() => {
        'Location_Id': id,
        'Location_Nombre': nombre,
        'Location_Codigo': codigo,
        'lat': lat,
        'long': long,
        'Parent_Location_Id': parentId,
      };

  factory LocationCatalog.fromRow(Map<String, dynamic> row) => LocationCatalog(
        id: _toInt(row['Location_Id']) ?? 0,
        nombre: (row['Location_Nombre'] ?? '').toString(),
        codigo: (row['Location_Codigo'] ?? '').toString(),
        lat: _toDouble(row['lat']),
        long: _toDouble(row['long']),
        parentId: _toInt(row['Parent_Location_Id']),
      );
}

class CropCatalog {
  const CropCatalog({required this.id, required this.nombre, required this.codigo});

  final int id;
  final String nombre;
  final String codigo;

  Map<String, dynamic> toRow() => {
        'Cultivo_Id': id,
        'Cultivo_Nombre': nombre,
        'Cultivo_Codigo': codigo,
      };

  factory CropCatalog.fromRow(Map<String, dynamic> row) => CropCatalog(
        id: _toInt(row['Cultivo_Id']) ?? 0,
        nombre: (row['Cultivo_Nombre'] ?? '').toString(),
        codigo: (row['Cultivo_Codigo'] ?? '').toString(),
      );
}

class GroupCatalog {
  const GroupCatalog({required this.id, required this.nombre, required this.codigo});

  final int id;
  final String nombre;
  final String codigo;

  Map<String, dynamic> toRow() => {
        'Grupo_Id': id,
        'Grupo_Nombre': nombre,
        'Grupo_Codigo': codigo,
      };

  factory GroupCatalog.fromRow(Map<String, dynamic> row) => GroupCatalog(
        id: _toInt(row['Grupo_Id']) ?? 0,
        nombre: (row['Grupo_Nombre'] ?? '').toString(),
        codigo: (row['Grupo_Codigo'] ?? '').toString(),
      );
}

class UserProfileRow {
  const UserProfileRow({
    required this.id,
    required this.codigo,
    this.employeeId,
    this.groupId,
    this.personId,
  });

  final int id;
  final String codigo;
  final int? employeeId;
  final int? groupId;
  final int? personId;

  Map<String, dynamic> toRow() => {
        'UserProfile_Id': id,
        'Codigo': codigo,
        'Empleado_Id': employeeId,
        'Grupo_Id': groupId,
        'Persona_Id': personId,
      };

  factory UserProfileRow.fromRow(Map<String, dynamic> row) => UserProfileRow(
        id: _toInt(row['UserProfile_Id']) ?? 0,
        codigo: (row['Codigo'] ?? '').toString(),
        employeeId: _toInt(row['Empleado_Id']),
        groupId: _toInt(row['Grupo_Id']),
        personId: _toInt(row['Persona_Id']),
      );
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  return int.tryParse(value.toString());
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString());
}

bool _toBool(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is int) return value != 0;
  final s = value.toString().toLowerCase();
  return s == 'true' || s == '1';
}
