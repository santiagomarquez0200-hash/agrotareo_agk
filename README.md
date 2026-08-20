# AgroTareo AGK

Aplicacion Flutter de campo (offline-first) que consume el backend real del
ERP Agrokasa (proxy `WSRESTMovilidadERP`) a traves de los Stored Procedures
definidos en `sp_agrotareo.sql`. La integracion de red replica el patron
verificado en produccion del proyecto hermano `agro_aplicaciones`.

## Backend real

| Concepto | Valor |
|---|---|
| Base URL Productivo | `https://agkwebagro.agrokasa.pe/WSRESTMovilidadERP/api` |
| Base URL Pruebas | `https://agkwebagro.agrokasa.pe/WSRESTMovilidadERPPruebas/api` |
| Login | `POST /login/authenticate` (headers `username` / `password`) → JWT |
| SP universal | `POST /EjecutarSPERP` (`Authorization: Bearer <token>`) |
| Contexto de usuario | `CLI547_AGMSP_AGK_GetUserContext` — sede, fundo, puesto, DNI, `UserProfileId`/`EmployeeId` reales del que inicia sesion |
| Sync maestro | `CLI547_AGM_MOBILE_MASTER_SYNC(@IdSede, @SinceVersion)` — 14 result sets (actividades, tipos de productividad, productos, ubicaciones, empleados, perfiles, grupos, subgrupos, variedades, cultivos, unidades de negocio, ordenes activas) + 1 extra (sublotes ERP WKT de **todos** los cultivos de la sede) cuando `@IdSede` no es NULL |
| Envio offline | `CLI547_AGM_MOBILE_SYNC_INSERT` — `@JsonData` con `tickages` y `productivity_logs` |

El toggle **Productivo / Pruebas** (icono junto al login y en el perfil)
cambia la base URL en caliente y la persiste en `SharedPreferences`; no
requiere recompilar la app.

> ⚠️ **Bug pendiente en el servidor**: `CLI547_AGMSP_AGK_GetUserContext`
> termina con `WHERE LTRIM(RTRIM(u.Codigo)) = 'JSANCHEZ'` en vez de
> `= @UsuarioCodigo` — ignora el parametro y siempre devuelve los datos de
> JSANCHEZ. La app ya envia `@UsuarioCodigo` correctamente y tiene un
> respaldo (busca el perfil en el catalogo sincronizado) si el SP falla,
> pero mientras no se corrija en el SQL Server, **todo login resolvera la
> sede/fundo/perfil de JSANCHEZ**, no los del usuario real. Hay que
> corregir esa linea en el servidor.

### Como se resuelve la sede sin pedirla a mano

1. Tras autenticar, se llama a `GetUserContext(@UsuarioCodigo)` y de ahi se
   toma `IdSede`.
2. El sync maestro (`MasterDataRepository.sync`) se dispara con ese
   `@IdSede` automaticamente — tanto en el login como en el boton
   "Sincronizar" de Inicio/Perfil/Mapa.
3. Como el SP ya devuelve, en esa misma llamada, los sublotes de **todos**
   los cultivos de la sede (ya no filtra por `@IdCultivo`), el mapa no
   necesita ninguna llamada ni parametro adicional: se pinta solo apenas
   hay `IdSede`.

## Arquitectura

```
lib/core/
  config/app_environment.dart     Entornos Productivo/Pruebas + override persistido
  network/erp_api_client.dart     Dio: login, ejecutarSP, cache de token (TTL 8h), parseo multi-tabla
  storage/session_storage.dart    Sesion del usuario + deviceId (flutter_secure_storage)
  services/app_services.dart      Orquesta login/logout/bootstrap; unico dueno del ApiClient
  sp/stored_procedure_contract.dart  Payloads exactos de los 3 SP reales

lib/data/
  models/          Employee, ActivityCatalog, LocationCatalog, CropCatalog,
                    GroupCatalog, UserProfileRow, FieldLot (sublotes ERP),
                    OutboxEvent (tickage + productivity_log), AuditRow, BackupSnapshot
  repositories/
    master_data_repository.dart   Cache + sync de catalogos (SharedPreferences)
    outbox_repository.dart        Cola de tareos offline, idempotente por temp_id
    audit_repository.dart         Auditoria local de envios
    backup_repository.dart        Snapshots locales con checksum sha256 real
```

No se usa ObjectBox/SQLite nativos (para no requerir codegen/toolchains
adicionales en este entorno): la persistencia offline-first se implementa con
`SharedPreferences` (JSON) y `flutter_secure_storage` para el token/sesion,
manteniendo el mismo contrato funcional (cola offline, watermark de
sincronizacion, auditoria, backups) sin dependencias nativas extra.

## Pantallas

- **Login**: usuario/contrasena reales contra el ERP, sin credenciales demo.
  Selector Productivo/Pruebas. Tras autenticar, sincroniza catalogos maestros
  y resuelve el perfil del usuario contra `Accounts_userprofile`.
- **Inicio**: resumen real de catalogos sincronizados y pendientes de envio.
- **Tareo**: selecciona ubicacion/actividad reales, escanea o busca al
  trabajador en el catalogo sincronizado y registra el tareo en el outbox.
- **Mapa**: sublotes ERP (WKT/centroide) de toda la sede del usuario,
  cargados automaticamente (sin pedir Id Sede / Id Cultivo).
- **Historial**: outbox pendientes/enviados + auditoria local; "Enviar" llama
  a `CLI547_AGM_MOBILE_SYNC_INSERT`.
- **Perfil**: usuario autenticado (sede/fundo/DNI/puesto reales via
  `GetUserContext`), boton "Sincronizar" y detalle de cada catalogo cargado
  (nombre + cantidad de filas, marcado en rojo si vino vacio) para validar
  a simple vista que el sync maestro trajo todo. Acceso al directorio de
  Personal y a los backups locales.
- **Personal**: directorio de empleados sincronizados con filtro por
  codigo, nombre o DNI (incluye boton de escaneo), y ficha de detalle por
  trabajador.

## Flujo de Tareo (parte / jornada)

Implementado segun `flujocompleto.md`, con `TareoRepository` (local,
SharedPreferences) orquestando el ciclo completo:

1. **Crear parte**: ubicacion + observacion opcional.
2. **Asistencia**: escaneo o busqueda de trabajador -> toggle ENTRADA/SALIDA.
3. **Actividades**: se crean dentro del parte (no se repite nombre), con
   producto/tipo de productividad opcionales y trabajadores asignados
   (solo los que tienen ENTRADA activa).
4. **Productividad**: por trabajador y actividad, validada contra el rango
   `Minimo`/`Maximo` del tipo de productividad del SP.
5. **Cerrar parte**: valida que todos tengan salida (o permite forzar). Al
   cerrar, arma un tickage real (`initial`/`final` = entrada/salida) por
   cada (trabajador, actividad) y sus `productivity_logs`, y los encola en
   el outbox para `CLI547_AGM_MOBILE_SYNC_INSERT`.

El `partes[]` del JSON de ejemplo en `flujocompleto.md` no lo procesa
`CLI547_AGM_MOBILE_SYNC_INSERT` (revisar `sp_agrotareo.sql`: solo maneja
`locations`, `activities`, `tickages`, `tickage_locations` y
`productivity_logs`) -- por eso el "parte" se modela como agrupador local
únicamente; lo que se sincroniza son los tickages/productivity_logs que
genera.

## Mapa satelital

`flutter_map` + capa **Esri World Imagery** (publica, sin API key) +
poligonos reales parseados de `GeometriaWKT` (POLYGON/MULTIPOLYGON). Toca
un poligono o un marcador para ver el detalle (cultivo, variedad,
hectareas). Filtros por cultivo y variedad. Si mas adelante hay una cuenta
de Google Maps/Mapbox, se cambia una sola constante
(`_tileUrlTemplate` en `map_page.dart`).

## Notas de produccion

- El token JWT se cachea localmente (TTL 8h); ante 401 se limpia la sesion y
  se redirige al login (no se guarda la contrasena en el dispositivo).
- El outbox reintenta manualmente desde Historial; los eventos quedan
  marcados `pending`/`sent`/`failed` con el ultimo error visible.
- `flutter analyze` y `flutter test` pasan sin issues (12 tests: parser
  multi-resultset del proxy, parser WKT, validacion de productividad,
  smoke test de login).
- Tema unico oscuro "enterprise" (`AgroTheme.dark()`), con la misma paleta
  del login aplicada a toda la app (AppBar, Drawer, Cards, NavigationBar,
  Chips, inputs).
