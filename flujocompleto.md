ESPECIFICACIÓN FUNCIONAL Y TÉCNICA DEL APK AGK (Offline-First)
1. VISIÓN GENERAL
AGK es un aplicativo móvil offline-first para la gestión de tareo agrícola y productividad en campo.
Permite a un líder/capataz:

Iniciar sesión y descargar catálogos maestros una sola vez (o cuando haya cambios).

Crear partes de trabajo (jornadas).

Registrar entradas/salidas de trabajadores mediante escaneo o búsqueda.

Crear actividades dentro de un parte.

Asignar trabajadores a actividades.

Registrar productividad por trabajador/actividad.

Cerrar partes.

Visualizar mapa de lotes/sublotes con geometrías.

Sincronizar todos los registros pendientes al backend Agrotareo cuando haya conexión.

Ver historial local con estados de sincronización.

La aplicación funciona 100% offline después de la descarga maestra, guardando todo en ObjectBox.

2. ARQUITECTURA LOCAL
2.1 Base de datos local (ObjectBox)
Se definen entidades espejo para los catálogos y transacciones.

Catálogos (solo lectura local)
Entidad	Fuente (SP maestro)
ActivityLocal	Tareo_activity
ProductivityTypeLocal	Tareo_productivitytype
ProductLocal	Tareo_product
ProductivityTypeProductLocal	Tareo_productivitytype_products
LocationLocal	Tareo_location
LocationTypeLocal	Master_locationtype
EmployeeLocal	Accounts_employee + Accounts_person
UserProfileLocal	Accounts_userprofile
GroupLocal	Tareo_group
SubgroupLocal	Tareo_subgroup
VarietyLocal	Tareo_variety
CropLocal	Tareo_crop
BusinessUnitLocal	Tareo_businessunit
TaskOrderLocal	ControlRoute_taskorder
SubplotMapLocal	Consulta Sublotes/Mapa ERP
Transacciones locales
Entidad	Descripción
ParteLocal	Jornada creada por el líder
AsistenciaLocal	Entrada/Salida de trabajador en un parte
ActividadParteLocal	Actividad creada dentro de un parte
TrabajadorActividadLocal	Asignación de trabajador a actividad
ProductividadLocal	Registro de productividad por trabajador/actividad
SyncLogLocal	Control de envío y estado de sincronización
Cada entidad transaccional tiene los campos:

temp_id (UUID generado local)

sync_status (PENDIENTE, SINCRONIZADO, ERROR)

fecha_creacion_local

fecha_modificacion_local

3. NAVEGACIÓN
Se usa BottomNavigationBar con 5 pestañas:

Índice	Pestaña	Icono	Descripción
0	Inicio	home	Bienvenida y KPI
1	Tareo	how_to_reg	Gestión de partes, asistencia, actividades, productividad
2	Mapa	map	Visualización satelital de lotes
3	Historial	history	Registro de transacciones locales
4	Perfil	person	Datos del usuario y sincronización
No hay menú lateral.

🏠 4. PANTALLA INICIO
Objetivo
Dar la bienvenida al líder y mostrar indicadores clave del día, calculados localmente.

Componentes visuales
Header con saludo: Hola, {NombreCompleto}

Tarjeta de estado:

Modo Online / Offline

Última sincronización (hace 5 min)

KPI Cards (2x2 o lista vertical):

Trabajadores activos (entradas - salidas del día)

Partes abiertos

Actividades creadas hoy

Productividad total del día (suma de quantity)

Botón principal: Nuevo Parte → navega a Tareo y abre flujo.

Lista de últimos registros sincronizados (máx. 5)

AsistenciaLocal y ProductividadLocal con estado SINCRONIZADO y hora.

Lógica de datos
Al abrir la pantalla, se consulta ObjectBox:

ParteLocal.filter(estado = ABIERTO).count()

AsistenciaLocal.filter(tipo = ENTRADA).count() - AsistenciaLocal.filter(tipo = SALIDA).count()

ActividadParteLocal.filter(fecha = hoy).count()

ProductividadLocal.filter(fecha = hoy).sum(quantity)

Acciones
Componente	Acción
Botón Nuevo Parte	Navega a la pestaña Tareo con flujo de creación
Tarjeta de estado	Muestra mensaje si hay registros pendientes
Últimos sincronizados	Al tocar, va a Historial
👷 5. PANTALLA TAREO
Es la más compleja. Se divide en secciones internas (tabs o pasos).

5.1 Objetivo
Permitir al líder:

Crear un parte.

Registrar entradas/salidas.

Crear actividades.

Asignar trabajadores a actividades.

Registrar productividad.

Cerrar parte.

5.2 Flujo principal
Paso 1: Seleccionar/Crear Parte
Si no hay parte abierto, se muestra un formulario:

Campaña (ControlRoute_taskorder o Master_campaign)

Hora inicio (auto)

Observación (opcional)

Al guardar, se crea ParteLocal con estado = ABIERTO.

Paso 2: Registro de Asistencia
Escáner QR o búsqueda manual.

Al leer/ingresar un trabajador:

Buscar en AsistenciaLocal si tiene entrada activa en ese parte.

Si no existe → registrar ENTRADA.

Si existe → registrar SALIDA.

Mostrar lista de trabajadores del parte con íconos de estado:

🟢 En labor

🔴 Salida

⚪ Sin registrar

Paso 3: Crear Actividad
Botón + Actividad.

Formulario:

Actividad (ActivityLocal)

Producto (ProductLocal)

Ubicación (LocationLocal) – jerarquía: Fundo → Lote → Sublote

Trabajadores: se muestran los que tienen ENTRADA en el parte actual.

Al guardar:

Crea ActividadParteLocal.

Crea múltiples TrabajadorActividadLocal.

Paso 4: Registrar Productividad
Dentro de cada ActividadParteLocal, botón Productividad.

Pantalla:

Lista de trabajadores asignados.

Para cada trabajador:

Producto (default de actividad)

Tipo productividad (según producto)

Cantidad (validada)

Hora (auto)

Al guardar, se crea ProductividadLocal con sync_status = PENDIENTE.

Paso 5: Cerrar Parte
Verificar que todos los trabajadores tengan salida.

Opción de forzar cierre.

Cambiar ParteLocal.estado = CERRADO.

5.3 Acciones y validaciones
Acción	Validación
Escanear trabajador	Verificar que exista en EmployeeLocal
Registrar salida	Solo si ya tiene entrada
Crear actividad	No puede existir otra con el mismo nombre en el mismo parte
Asignar trabajador	Solo trabajadores con ENTRADA
Registrar productividad	Cantidad entre minvalue y maxvalue
Cerrar parte	Todos los trabajadores con salida (o forzar)
🗺️ 6. PANTALLA MAPA
Objetivo
Mostrar el mapa satelital con los lotes/sublotes de la sede, con colores por cultivo.

Implementación
Librería: flutter_map + capa de OpenStreetMap/Google Maps.

Datos desde SubplotMapLocal (descargados por SP maestro).

Polígonos generados a partir de GeometriaWKT.

Centroides con marcadores.

Al tocar un polígono, mostrar popup con:

Nombre de sublote

Cultivo

Variedad

Hectáreas

Filtros opcionales
Por cultivo (checkboxes con colores)

Por variedad

📜 7. PANTALLA HISTORIAL
Objetivo
Mostrar todos los registros locales con su estado de sincronización.

Contenido
Lista filtrable por:

Tipo (Partes, Asistencias, Productividades)

Estado (PENDIENTE, SINCRONIZADO, ERROR)

Fecha

Cada tarjeta muestra:

Tipo y descripción

Fecha/hora

Estado con icono

Intento de sincronización (si falló)

⚙️ 8. PANTALLA PERFIL
Objetivo
Mostrar datos del usuario y permitir configuración/sincronización.

Contenido
Nombre completo

DNI

Puesto

Código trabajador

Sede

Fundo

Switch Online/Offline para forzar modo sin red

Botón Sincronizar ahora

Botón Cerrar sesión

🔄 9. SINCRONIZACIÓN
9.1 Proceso
Verificar conexión.

Leer registros PENDIENTE.

Armar JSON.

Enviar a endpoint CLI547_AGM_MOBILE_SYNC_INSERT.

Recibir respuesta.

Marcar registros como SINCRONIZADO o mantener PENDIENTE.

9.2 JSON de sincronización
json
{
  "partes": [
    {
      "temp_id": "parte-123",
      "campaign_id": 2,
      "fecha": "2026-08-14",
      "hora_inicio": "07:00:00",
      "hora_fin": "15:00:00",
      "estado": "CERRADO"
    }
  ],
  "tickages": [
    {
      "temp_id": "tick-001",
      "parte_temp_id": "parte-123",
      "employee_id": 10541,
      "activity_id": null,
      "location_id": 185,
      "type": "ENTRADASALIDA",
      "initial": "2026-08-14T07:00:00Z",
      "final": "2026-08-14T15:00:00Z",
      "user_id": 26
    }
  ],
  "tickage_locations": [
    {
      "tickage_temp_id": "tick-001",
      "location_id": 185
    }
  ],
  "productivity_logs": [
    {
      "tickage_temp_id": "tick-001",
      "employee_id": 10541,
      "productivity_type_id": 35,
      "product_id": 1390,
      "location_id": 185,
      "quantity": 500.0,
      "readtime": "2026-08-14T09:15:00Z",
      "userprofile_id": 26
    }
  ]
}
🔁 10. CONSUMO DEL SP MAESTRO
El SP CLI547_AGM_MOBILE_MASTER_SYNC devuelve múltiples resultsets.
Para que la app funcione offline, debe leerlos todos.

Posible problema detectado
El proxy actual solo está leyendo el primer resultset (Tareo_activity), por lo que la app solo recibe 1 de 15 tablas.

Solución recomendada
Modificar el SP maestro para que devuelva un solo JSON con FOR JSON PATH, agrupando todos los catálogos en una estructura jerárquica, evitando el multi-resultset.

Ejemplo:

sql
SELECT
    (SELECT ... FROM Tareo_activity FOR JSON PATH) AS activities,
    (SELECT ... FROM Tareo_productivitytype FOR JSON PATH) AS productivity_types,
    ...
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
Así la app recibe un JSON unificado fácil de parsear.

📊 11. DIAGRAMA DE FLUJO GENERAL
text
INICIO
  │
  ▼
LOGIN (usuario/código)
  │
  ▼
GET USER CONTEXT (SP perfil)
  │
  ▼
DESCARGA MAESTRA (SP maestro) → Guardar en ObjectBox
  │
  ▼
MODO OFFLINE
  │
  ├─ CREAR PARTE
  │    │
  │    ▼
  │  REGISTRAR ENTRADAS/SALIDAS
  │    │
  │    ▼
  │  CREAR ACTIVIDADES
  │    │
  │    ▼
  │  ASIGNAR TRABAJADORES
  │    │
  │    ▼
  │  REGISTRAR PRODUCTIVIDAD
  │    │
  │    ▼
  │  CERRAR PARTE
  │
  └─ (acumular pendientes)
       │
       ▼
DETECTAR CONEXIÓN
       │
       ▼
ARMAR JSON CON PENDIENTES
       │
       ▼
ENVIAR AL SP DE SINCRONIZACIÓN
       │
       ▼
RECIBIR RESPUESTA
       │
       ├─ OK → marcar SINCRONIZADO
       │
       └─ ERROR → mantener PENDIENTE y reintentar
