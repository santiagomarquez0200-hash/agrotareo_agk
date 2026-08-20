CREATE OR ALTER PROCEDURE [dbo].[CLI547_AGM_MOBILE_MASTER_SYNC]
(
    @IdSede       INT    = NULL,
    @SinceVersion BIGINT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    -- =========================================================
    -- 1. ACTIVIDADES (GLOBAL)
    -- =========================================================
    SELECT
        id                  AS Activity_Id,
        code                AS Activity_Codigo,
        extcode             AS Activity_ExtCode,
        name                AS Activity_Nombre,
        productive          AS EsProductiva,
        isgroupal           AS EsGrupal,
        productivitylecture AS ModoLectura,
        product_default_id  AS ProductoDefault_Id
    FROM agrotareo.dbo.Tareo_activity
    WHERE active = 1
    OPTION (RECOMPILE);

    -- =========================================================
    -- 2. TIPOS DE PRODUCTIVIDAD
    -- =========================================================
    SELECT
        id                    AS ProductivityType_Id,
        name                  AS ProductivityType_Nombre,
        productivitylecture   AS ModoLectura,
        default_value         AS ValorDefecto,
        minvalue              AS Minimo,
        maxvalue              AS Maximo,
        steppervalue          AS Incremento,
        can_repeat            AS PuedeRepetir,
        app_visible           AS VisibleEnApp,
        businessunit_id,
        container_type_id,
        max_container_value,
        collection_rate_id
    FROM agrotareo.dbo.Tareo_productivitytype
    OPTION (RECOMPILE);

    -- =========================================================
    -- 3. PRODUCTOS
    -- =========================================================
    SELECT
        id            AS Product_Id,
        name          AS Product_Nombre,
        code          AS Product_Codigo,
        extcode       AS Product_ExtCode,
        container     AS EsContenedor,
        active        AS Activo,
        consumible    AS Consumible,
        businessunit_id
    FROM agrotareo.dbo.Tareo_product
    WHERE active = 1
    OPTION (RECOMPILE);

    -- =========================================================
    -- 4. RELACIÓN TIPO-PRODUCTO
    -- =========================================================
    SELECT
        id                  AS Relacion_Id,
        productivitytype_id AS ProductivityType_Id,
        product_id          AS Product_Id
    FROM agrotareo.dbo.Tareo_productivitytype_products
    OPTION (RECOMPILE);

    -- =========================================================
    -- 5. UBICACIONES (GLOBAL)
    -- =========================================================
    SELECT
        id          AS Location_Id,
        name        AS Location_Nombre,
        code        AS Location_Codigo,
        lector_code AS Location_LectorCode,
        area        AS Area,
        parent_id   AS Parent_Location_Id,
        type_id     AS TipoUbicacion_Id,
        lat,
        long
    FROM agrotareo.dbo.Tareo_location
    WHERE end_date IS NULL OR end_date >= CAST(GETDATE() AS DATE)
    OPTION (RECOMPILE);

    -- =========================================================
    -- 6. TIPOS DE UBICACIÓN
    -- =========================================================
    SELECT
        id,
        code,
        name
    FROM agrotareo.dbo.Master_locationtype
    OPTION (RECOMPILE);

    -- =========================================================
    -- 7. EMPLEADOS
    -- =========================================================
    SELECT
        ae.id               AS Employee_Id,
        ae.codeworker       AS CodigoTrabajador,
        ae.idworker         AS IdWorkerERP,
        ae.active           AS Activo,
        ae.location_id      AS Ubicacion_Id,
        ae.person_id        AS Persona_Id,
        ae.supplier_id      AS Proveedor_Id,
        p.identification    AS Documento,
        p.name              AS Nombre,
        p.firstname         AS SegundoNombre,
        p.lastname          AS Apellidos
    FROM agrotareo.dbo.Accounts_employee ae
    LEFT JOIN agrotareo.dbo.Accounts_person p ON p.id = ae.person_id
    WHERE ae.active = 1
    OPTION (RECOMPILE);

    -- =========================================================
    -- 8. PERFILES DE USUARIO (LÍDERES)
    -- =========================================================
    SELECT
        id               AS UserProfile_Id,
        code             AS Codigo,
        employee_id      AS Empleado_Id,
        group_id         AS Grupo_Id,
        person_id        AS Persona_Id,
        superintendent_id,
        user_id
    FROM agrotareo.dbo.Accounts_userprofile
    OPTION (RECOMPILE);

    -- =========================================================
    -- 9. GRUPOS Y SUBGRUPOS
    -- =========================================================
    SELECT
        id       AS Grupo_Id,
        name     AS Grupo_Nombre,
        code     AS Grupo_Codigo,
        active   AS Activo
    FROM agrotareo.dbo.Tareo_group
    WHERE active = 1
    OPTION (RECOMPILE);

    SELECT
        id       AS Subgrupo_Id,
        name     AS Subgrupo_Nombre,
        code     AS Subgrupo_Codigo,
        group_id AS Grupo_Id,
        active   AS Activo
    FROM agrotareo.dbo.Tareo_subgroup
    WHERE active = 1
    OPTION (RECOMPILE);

    -- =========================================================
    -- 10. VARIEDADES Y CULTIVOS
    -- =========================================================
    SELECT
        id       AS Variedad_Id,
        name     AS Variedad_Nombre,
        code     AS Variedad_Codigo,
        active   AS Activo
    FROM agrotareo.dbo.Tareo_variety
    WHERE active = 1
    OPTION (RECOMPILE);

    SELECT
        id       AS Cultivo_Id,
        name     AS Cultivo_Nombre,
        code     AS Cultivo_Codigo,
        active   AS Activo
    FROM agrotareo.dbo.Tareo_crop
    WHERE active = 1
    OPTION (RECOMPILE);

    -- =========================================================
    -- 11. UNIDADES DE NEGOCIO
    -- =========================================================
    SELECT
        id       AS BusinessUnit_Id,
        name     AS BusinessUnit_Nombre,
        code     AS BusinessUnit_Codigo,
        active   AS Activo
    FROM agrotareo.dbo.Tareo_businessunit
    WHERE active = 1
    OPTION (RECOMPILE);

    -- =========================================================
    -- 12. ÓRDENES DE TRABAJO ACTIVAS
    -- =========================================================
    SELECT
        id          AS TaskOrder_Id,
        start_time  AS Inicio,
        end_time    AS Fin,
        code        AS Codigo,
        user_id     AS UserProfile_Id,
        campaign_id AS Campaña_Id
    FROM agrotareo.dbo.ControlRoute_taskorder
    WHERE end_time IS NULL OR end_time >= CAST(GETDATE() AS DATE)
    OPTION (RECOMPILE);

    -- =========================================================
    -- 13. SUBLOTES / MAPA (FILTRADO POR SEDE)
    -- =========================================================
    IF @IdSede IS NOT NULL
    BEGIN
        SELECT
            cuLP.Id                                                          AS Id,
            (SELECT TOP 1 ca.Id FROM dbo.Campanyas ca
             WHERE ca.Componente = 1 ORDER BY ca.FechaInicial DESC)         AS Id_Campanya,
            @IdSede                                                         AS Id_Sede,
            fi.Id_Representante                                             AS Id_Fundo,
            eb.Id                                                           AS Id_Cultivo,
            ebv.Id                                                          AS Id_Variedad,
            fi.Id                                                           AS Id_Lote,
            cuLP.Id                                                         AS Id_Sublote,
            fi.Nombre                                                       AS Nombre_Lote,
            'BAJA'                                                          AS Prioridad,
            'CATALOGO'                                                      AS Estado,
            CONVERT(VARCHAR(10), GETDATE(), 120)                            AS FechaProgramada,
            NULL                                                            AS CoordenadasPoligono,
            NULL                                                            AS UsuarioAsignado,
            ISNULL(CAST(cuLP.SuperficieCultivada / 10000.0 AS DECIMAL(10,2)), 1.0) AS HectareasLote,
            NULL                                                            AS TotalPlantas,
            eb.NombreComun                                                  AS NombreCultivo,
            ebv.Denominacion                                                AS NombreVariedad,
            z.Nombre                                                        AS NombreSede,
            cuLP.Descripcion                                                AS NombreSublote,
            CASE WHEN geo.Geometria IS NOT NULL
                 THEN geo.Geometria.STAsText() ELSE NULL END                AS GeometriaWKT,
            CASE WHEN geo.Geometria IS NOT NULL
                 THEN geo.Geometria.STCentroid().STY ELSE NULL END           AS LatitudCentro,
            CASE WHEN geo.Geometria IS NOT NULL
                 THEN geo.Geometria.STCentroid().STX ELSE NULL END           AS LongitudCentro,
            CASE
                WHEN eb.NombreComun = 'UVA'       THEN '#8E44AD'
                WHEN eb.NombreComun = 'PALTO'     THEN '#27AE60'
                WHEN eb.NombreComun = 'ESPARRAGO' THEN '#E67E22'
                WHEN eb.NombreComun = 'ARANDANO'  THEN '#2980B9'
                ELSE '#95A5A6'
            END                                                              AS ColorCultivo,
            CAST(cuLP.Version AS BIGINT)                                     AS Version
        FROM ERPHispatec.dbo.Cultivos AS cuLP WITH (NOLOCK)
        INNER JOIN dbo.Fincas fi WITH (NOLOCK) ON fi.Id = cuLP.Id_Finca
        INNER JOIN dbo.Fincas_DatosComplementarios fdc WITH (NOLOCK) ON fi.Id = fdc.Id_Fincas
        INNER JOIN dbo.DatoComplementarioValor dcvc WITH (NOLOCK) ON dcvc.Id = fdc.Id_DatosComplementarios
        INNER JOIN dbo.DatosComplementarios dcc WITH (NOLOCK) ON dcc.Id = dcvc.Id_DatoComplementario AND dcc.Codigo = 'VAR'
        INNER JOIN dbo.EspecieBotanicaVariedad ebv WITH (NOLOCK) ON ebv.Id = dcvc.Valor
        INNER JOIN dbo.EspeciesBotanicas eb WITH (NOLOCK) ON eb.Id = ebv.Id_EspecieBotanica
        LEFT JOIN ERPHispatec.dbo.Zonas z WITH (NOLOCK) ON z.Id = fi.Id_Zona
        OUTER APPLY (
            SELECT TOP 1 g.Geometria
            FROM dbo.Cultivos_Coordenadas cc2 WITH (NOLOCK)
            JOIN dbo.CoordenadaGPS g WITH (NOLOCK) ON g.Id = cc2.Id_Coordenadas AND g.Geometria IS NOT NULL
            WHERE cc2.Id_Cultivos = cuLP.Id
        ) geo
        WHERE TRY_CAST(dcvc.Valor AS FLOAT) IS NOT NULL
          AND fi.Id_Zona = @IdSede
          AND (@SinceVersion IS NULL OR cuLP.Version > @SinceVersion)
        ORDER BY fi.Nombre, cuLP.Descripcion;
    END
END;
GO

CREATE OR ALTER PROCEDURE [dbo].[CLI547_AGM_MOBILE_SYNC_INSERT]
    @JsonData NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF ISJSON(@JsonData) = 0
        BEGIN
            RAISERROR('El parámetro @JsonData no es JSON válido.', 16, 1);
            RETURN;
        END

        DECLARE @TickageMap TABLE (TempId NVARCHAR(50), NewId INT);
        DECLARE @LocationMap TABLE (TempId NVARCHAR(50), NewId INT);
        DECLARE @ActivityMap TABLE (TempId NVARCHAR(50), NewId INT);

        -- =========================================================
        -- 1. CREACIÓN OPCIONAL DE NUEVAS UBICACIONES
        -- =========================================================
        IF EXISTS (SELECT 1 FROM OPENJSON(@JsonData, '$.locations'))
        BEGIN
            INSERT INTO agrotareo.dbo.Tareo_location (
                name, code, lector_code, center, area, parent_id, supplier_id, type_id, lat, long
            )
            OUTPUT source.temp_id, inserted.id
            INTO @LocationMap (TempId, NewId)
            SELECT
                source.name,
                source.code,
                source.lector_code,
                source.center,
                source.area,
                source.parent_id,
                source.supplier_id,
                source.type_id,
                source.lat,
                source.long
            FROM OPENJSON(@JsonData, '$.locations')
            WITH (
                temp_id NVARCHAR(50) '$.temp_id',
                name NVARCHAR(200) '$.name',
                code NVARCHAR(50) '$.code',
                lector_code NVARCHAR(50) '$.lector_code',
                center NVARCHAR(100) '$.center',
                area NVARCHAR(100) '$.area',
                parent_id INT '$.parent_id',
                supplier_id INT '$.supplier_id',
                type_id INT '$.type_id',
                lat FLOAT '$.lat',
                long FLOAT '$.long'
            ) AS source;
        END

        -- =========================================================
        -- 2. CREACIÓN OPCIONAL DE NUEVAS ACTIVIDADES
        -- =========================================================
        IF EXISTS (SELECT 1 FROM OPENJSON(@JsonData, '$.activities'))
        BEGIN
            INSERT INTO agrotareo.dbo.Tareo_activity (
                name, code, extcode, active, productive, isgroupal, productivitylecture, creation
            )
            OUTPUT source.temp_id, inserted.id
            INTO @ActivityMap (TempId, NewId)
            SELECT
                source.name,
                source.code,
                source.extcode,
                source.active,
                source.productive,
                source.isgroupal,
                source.productivitylecture,
                GETDATE()
            FROM OPENJSON(@JsonData, '$.activities')
            WITH (
                temp_id NVARCHAR(50) '$.temp_id',
                name NVARCHAR(200) '$.name',
                code NVARCHAR(50) '$.code',
                extcode NVARCHAR(50) '$.extcode',
                active BIT '$.active',
                productive BIT '$.productive',
                isgroupal BIT '$.isgroupal',
                productivitylecture NVARCHAR(50) '$.productivitylecture'
            ) AS source;
        END

        -- =========================================================
        -- 3. INSERCIÓN DE TICKAJES (ControlRoute_tickage)
        -- =========================================================
        IF EXISTS (SELECT 1 FROM OPENJSON(@JsonData, '$.tickages'))
        BEGIN
            INSERT INTO agrotareo.dbo.ControlRoute_tickage (
                initial,
                final,
                fecha,
                initialValidate,
                finalValidate,
                state,
                state_error,
                type,
                duration,
                incidence,
                remote,
                observations,
                latitude,
                longitude,
                cantidad_productividad,
                extcode_inp,
                extcode_out,
                activity_id,
                crop_id,
                employee_id,
                group_id,
                incidencetype_id,
                location_id,
                location_out_id,
                person_id,
                planning_id,
                planning_out_id,
                product_id,
                subgroup_id,
                task_order_id,
                user_id,
                user_out_id,
                variety_id,
                wagetype_id,
                waypoint_id,
                waypointexit_id,
                supplier_id,
                utc,
                utc_out,
                absence_id,
                campaign_id,
                break_sent,
                break_group_id,
                work_position_id,
                break_duration,
                created
            )
            OUTPUT source.temp_id, inserted.id
            INTO @TickageMap (TempId, NewId)
            SELECT
                source.initial,
                source.final,
                CAST(source.initial AS DATE),
                source.initialValidate,
                source.finalValidate,
                source.state,
                source.state_error,
                source.type,
                source.duration,
                source.incidence,
                source.remote,
                source.observations,
                source.latitude,
                source.longitude,
                source.cantidad_productividad,
                source.extcode_inp,
                source.extcode_out,
                source.activity_id,
                source.crop_id,
                source.employee_id,
                source.group_id,
                source.incidencetype_id,
                source.location_id,
                source.location_out_id,
                source.person_id,
                source.planning_id,
                source.planning_out_id,
                source.product_id,
                source.subgroup_id,
                source.task_order_id,
                source.user_id,
                source.user_out_id,
                source.variety_id,
                source.wagetype_id,
                source.waypoint_id,
                source.waypointexit_id,
                source.supplier_id,
                source.utc,
                source.utc_out,
                source.absence_id,
                source.campaign_id,
                source.break_sent,
                source.break_group_id,
                source.work_position_id,
                source.break_duration,
                GETDATE()
            FROM OPENJSON(@JsonData, '$.tickages')
            WITH (
                temp_id NVARCHAR(50) '$.temp_id',
                initial DATETIME '$.initial',
                final DATETIME '$.final',
                initialValidate DATETIME '$.initialValidate',
                finalValidate DATETIME '$.finalValidate',
                state VARCHAR(20) '$.state',
                state_error VARCHAR(100) '$.state_error',
                type VARCHAR(50) '$.type',
                duration DECIMAL(10,2) '$.duration',
                incidence BIT '$.incidence',
                remote BIT '$.remote',
                observations NVARCHAR(500) '$.observations',
                latitude DECIMAL(18,6) '$.latitude',
                longitude DECIMAL(18,6) '$.longitude',
                cantidad_productividad DECIMAL(18,2) '$.cantidad_productividad',
                extcode_inp NVARCHAR(50) '$.extcode_inp',
                extcode_out NVARCHAR(50) '$.extcode_out',
                activity_id INT '$.activity_id',
                crop_id INT '$.crop_id',
                employee_id INT '$.employee_id',
                group_id INT '$.group_id',
                incidencetype_id INT '$.incidencetype_id',
                location_id INT '$.location_id',
                location_out_id INT '$.location_out_id',
                person_id INT '$.person_id',
                planning_id INT '$.planning_id',
                planning_out_id INT '$.planning_out_id',
                product_id INT '$.product_id',
                subgroup_id INT '$.subgroup_id',
                task_order_id INT '$.task_order_id',
                user_id INT '$.user_id',
                user_out_id INT '$.user_out_id',
                variety_id INT '$.variety_id',
                wagetype_id INT '$.wagetype_id',
                waypoint_id INT '$.waypoint_id',
                waypointexit_id INT '$.waypointexit_id',
                supplier_id INT '$.supplier_id',
                utc NVARCHAR(50) '$.utc',
                utc_out NVARCHAR(50) '$.utc_out',
                absence_id INT '$.absence_id',
                campaign_id INT '$.campaign_id',
                break_sent BIT '$.break_sent',
                break_group_id INT '$.break_group_id',
                work_position_id INT '$.work_position_id',
                break_duration DECIMAL(10,2) '$.break_duration'
            ) AS source;
        END

        -- =========================================================
        -- 4. INSERCIÓN DE UBICACIONES DEL TICKAJE
        -- =========================================================
        IF EXISTS (SELECT 1 FROM OPENJSON(@JsonData, '$.tickage_locations'))
        BEGIN
            INSERT INTO agrotareo.dbo.ControlRoute_tickage_locations (
                tickage_id,
                location_id
            )
            SELECT
                tm.NewId,
                tl.location_id
            FROM OPENJSON(@JsonData, '$.tickage_locations')
            WITH (
                tickage_temp_id NVARCHAR(50) '$.tickage_temp_id',
                location_id INT '$.location_id'
            ) AS tl
            INNER JOIN @TickageMap tm ON tm.TempId = tl.tickage_temp_id;
        END

        -- =========================================================
        -- 5. INSERCIÓN DE PRODUCTIVIDADES (Tareo_productivity_log)
        -- =========================================================
        IF EXISTS (SELECT 1 FROM OPENJSON(@JsonData, '$.productivity_logs'))
        BEGIN
            INSERT INTO agrotareo.dbo.Tareo_productivity_log (
                readtime,
                quantity,
                businessunit_id_id,
                employee_id_id,
                location_id_id,
                logistic_unit_id,
                parent_id,
                product_id,
                productivity_type_id,
                subgroup_id,
                tickaje_id_id,
                userprofile_id,
                group_id,
                annotation,
                initialValidate,
                created_at
            )
            SELECT
                pl.readtime,
                pl.quantity,
                pl.businessunit_id_id,
                pl.employee_id,
                pl.location_id,
                pl.logistic_unit_id,
                pl.parent_id,
                pl.product_id,
                pl.productivity_type_id,
                pl.subgroup_id,
                tm.NewId,
                pl.userprofile_id,
                pl.group_id,
                pl.annotation,
                pl.initialValidate,
                GETDATE()
            FROM OPENJSON(@JsonData, '$.productivity_logs')
            WITH (
                tickage_temp_id NVARCHAR(50) '$.tickage_temp_id',
                readtime DATETIME '$.readtime',
                quantity DECIMAL(18,3) '$.quantity',
                businessunit_id_id INT '$.businessunit_id_id',
                employee_id INT '$.employee_id',
                location_id INT '$.location_id',
                logistic_unit_id INT '$.logistic_unit_id',
                parent_id INT '$.parent_id',
                product_id INT '$.product_id',
                productivity_type_id INT '$.productivity_type_id',
                subgroup_id INT '$.subgroup_id',
                userprofile_id INT '$.userprofile_id',
                group_id INT '$.group_id',
                annotation NVARCHAR(255) '$.annotation',
                initialValidate DATETIME '$.initialValidate'
            ) AS pl
            INNER JOIN @TickageMap tm ON tm.TempId = pl.tickage_temp_id;
        END

        COMMIT TRANSACTION;

        -- =========================================================
        -- 6. RESPUESTA FINAL
        -- =========================================================
        SELECT
            'OK' AS Resultado,
            (SELECT COUNT(*) FROM @TickageMap) AS TickagesInsertados,
            (SELECT COUNT(*) FROM @LocationMap) AS UbicacionesInsertadas,
            (SELECT COUNT(*) FROM @ActivityMap) AS ActividadesInsertadas;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT 'ERROR' AS Resultado, ERROR_MESSAGE() AS ErrorMensaje;
    END CATCH;
END;
go
-----

-------
  CREATE  PROCEDURE [dbo].[CLI547_AGMSP_AGK_GetUserContext]
    @UsuarioCodigo VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    SET @UsuarioCodigo = LTRIM(RTRIM(@UsuarioCodigo));

    IF NOT EXISTS (
        SELECT 1 FROM dbo.Usuarios WHERE LTRIM(RTRIM(Codigo)) = @UsuarioCodigo
    )
    BEGIN
        RAISERROR('Usuario [%s] no encontrado en la tabla Usuarios.', 16, 1, @UsuarioCodigo);
        RETURN;
    END

    SELECT TOP 1
        u.Codigo                                 AS CodigoUsuario,
        CONCAT(s.Nombre, ' ', s.PrimerApellido, ' ', s.SegundoApellido) AS NombreCompleto,
        s.Identificador                          AS DNI,
        pt.Descripcion                           AS PuestoTrabajo,
        SUBSTRING(t.Codigo, 6, LEN(t.Codigo))    AS CodigoTrabajador,
        ISNULL(z.Nombre COLLATE SQL_Latin1_General_CP1_CI_AI, 'Sede Central') AS Sede,
        z.Id                                     AS IdSede,
        ISNULL(up.center, ae.location_id)        AS CentroAgrotareo,
        up.id                                    AS UserProfileId,
        ae.id                                    AS EmployeeId,
        t.Id                                     AS IdWorkerERP,
        -- Fundo real basado en la sede
        ISNULL(f.PrimerApellido COLLATE SQL_Latin1_General_CP1_CI_AI, 'Fundo General') AS Fundo,
        f.Id                                     AS IdFundo,
        CASE 
            WHEN u.FechaUltimaConexion >= DATEADD(MONTH, -3, GETDATE()) THEN 'Activo'
            WHEN u.FechaUltimaConexion IS NOT NULL THEN 'Inactivo'
            ELSE 'Sin accesos'
        END                                       AS EstadoDescripcion,
        CAST(u.FechaCreacion AS DATE)             AS FechaCreacionUsuario
    FROM dbo.Usuarios u
    LEFT JOIN dbo.Sujetos s ON u.id_sujeto = s.id
    LEFT JOIN dbo.Trabajadores t ON s.id = t.Id_Sujeto
    LEFT JOIN dbo.PuestoTrabajo pt ON t.id_puestotrabajo = pt.id

    -- Relación con Agrotareo
    LEFT JOIN agrotareo.dbo.Accounts_employee ae ON ae.idworker = t.Id
    LEFT JOIN agrotareo.dbo.Accounts_userprofile up ON up.employee_id = ae.id

    -- Dirección / Sede (ERP)
    LEFT JOIN dbo.DireccionesSujeto ds ON s.Id = ds.Id_Sujeto
    LEFT JOIN dbo.Direcciones d ON ds.Id_Direccion = d.Id
    LEFT JOIN dbo.Zonas z ON d.Id_Zona = z.Id

    -- Relación Sede -> Fundo (asumiendo que Fincas.Id_Representante apunta a Sujetos con Nombre='FUNDO')
    OUTER APPLY (
        SELECT TOP 1
            s2.Id               AS Id,
            s2.PrimerApellido   AS PrimerApellido
        FROM dbo.Fincas fi
        INNER JOIN dbo.Sujetos s2 ON s2.Id = fi.Id_Representante
                                AND s2.Nombre = 'FUNDO'
        WHERE fi.Id_Zona = z.Id
        ORDER BY fi.Id DESC   -- Tomar el más reciente
    ) f

    WHERE LTRIM(RTRIM(u.Codigo)) = 'JSANCHEZ'
    ORDER BY u.FechaCreacion DESC;
END