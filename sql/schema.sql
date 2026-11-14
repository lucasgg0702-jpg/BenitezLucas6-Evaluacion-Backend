-- Lo de Chicho: esquema de la base de datos
-- Compatible con MySQL y con MariaDB (XAMPP)

-- ---------------------------------------------------------------
-- MENÚ
-- Los precios se guardan en pesos enteros (INT), sin centavos.
-- ---------------------------------------------------------------

CREATE TABLE IF NOT EXISTS categorias (
  id     INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(80)  NOT NULL,
  orden  INT          NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS platos (
  id           INT UNSIGNED NOT NULL AUTO_INCREMENT,
  categoria_id INT UNSIGNED NOT NULL,
  nombre       VARCHAR(120) NOT NULL,
  descripcion  TEXT         NULL,
  -- precio es NULL cuando el plato tiene variantes (cada una con su precio)
  precio       INT UNSIGNED NULL,
  imagen_url   VARCHAR(500) NULL,
  imagen_id    VARCHAR(200) NULL,
  disponible   TINYINT(1)   NOT NULL DEFAULT 1,
  orden        INT          NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  KEY idx_platos_categoria (categoria_id),
  -- No se puede borrar una categoría que todavía tenga platos
  CONSTRAINT fk_platos_categoria
    FOREIGN KEY (categoria_id) REFERENCES categorias (id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS variantes (
  id       INT UNSIGNED NOT NULL AUTO_INCREMENT,
  plato_id INT UNSIGNED NOT NULL,
  nombre   VARCHAR(80)  NOT NULL,
  precio   INT UNSIGNED NOT NULL,
  orden    INT          NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  KEY idx_variantes_plato (plato_id),
  CONSTRAINT fk_variantes_plato
    FOREIGN KEY (plato_id) REFERENCES platos (id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------
-- NOVEDADES
-- Sin estado ni vencimiento: si está cargada, se ve.
-- ---------------------------------------------------------------

CREATE TABLE IF NOT EXISTS novedades (
  id          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  tipo        ENUM('oferta', 'combo', 'plato_del_dia') NOT NULL,
  titulo      VARCHAR(120) NOT NULL,
  descripcion TEXT         NULL,
  imagen_url  VARCHAR(500) NULL,
  imagen_id   VARCHAR(200) NULL,
  creada_en   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------
-- PEDIDOS
-- El nombre y el precio de cada plato se copian dentro del pedido, así
-- los cambios posteriores del menú no alteran los pedidos anteriores.
-- ---------------------------------------------------------------

CREATE TABLE IF NOT EXISTS pedidos (
  id             INT UNSIGNED NOT NULL AUTO_INCREMENT,
  codigo         VARCHAR(12)  NOT NULL,
  nombre_cliente VARCHAR(120) NOT NULL,
  tipo_entrega   ENUM('retiro', 'delivery') NOT NULL,
  costo_envio    INT UNSIGNED NOT NULL DEFAULT 0,
  metodo_pago    VARCHAR(30)  NOT NULL,
  total          INT UNSIGNED NOT NULL,
  estado         ENUM('pendiente', 'confirmado') NOT NULL DEFAULT 'pendiente',
  creado_en      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_pedidos_estado_fecha (estado, creado_en),
  KEY idx_pedidos_codigo (codigo)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS pedido_items (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
  pedido_id       INT UNSIGNED NOT NULL,
  plato_id        INT UNSIGNED NULL,
  nombre_plato    VARCHAR(120) NOT NULL,
  variante        VARCHAR(80)  NULL,
  precio_unitario INT UNSIGNED NOT NULL,
  cantidad        INT UNSIGNED NOT NULL,
  PRIMARY KEY (id),
  KEY idx_items_pedido (pedido_id),
  CONSTRAINT fk_items_pedido
    FOREIGN KEY (pedido_id) REFERENCES pedidos (id) ON DELETE CASCADE,
  -- Si se borra un plato del menú, el pedido conserva su nombre y precio
  CONSTRAINT fk_items_plato
    FOREIGN KEY (plato_id) REFERENCES platos (id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ---------------------------------------------------------------
-- USUARIOS DEL PANEL (dueño y soporte)
-- ---------------------------------------------------------------

CREATE TABLE IF NOT EXISTS usuarios (
  id            INT UNSIGNED NOT NULL AUTO_INCREMENT,
  usuario       VARCHAR(60)  NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  creado_en     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_usuarios_usuario (usuario)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------
-- CONFIGURACIÓN (una sola fila, siempre con id = 1)
-- ---------------------------------------------------------------

CREATE TABLE IF NOT EXISTS configuracion (
  id            TINYINT UNSIGNED NOT NULL DEFAULT 1,
  local_abierto TINYINT(1)       NOT NULL DEFAULT 1,
  costo_envio   INT UNSIGNED     NOT NULL DEFAULT 1000,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

INSERT IGNORE INTO configuracion (id, local_abierto, costo_envio)
VALUES (1, 1, 1000);
