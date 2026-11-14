-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 28-10-2026 a las 20:34:37
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `lo_de_chicho`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `id` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(80) NOT NULL,
  `orden` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`id`, `nombre`, `orden`) VALUES
(1, 'Hamburguesas', 1),
(2, 'Empanadas', 3),
(3, 'Bebidas', 4),
(4, 'Pizzas', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuracion`
--

CREATE TABLE `configuracion` (
  `id` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `local_abierto` tinyint(1) NOT NULL DEFAULT 1,
  `costo_envio` int(10) UNSIGNED NOT NULL DEFAULT 1000
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `configuracion`
--

INSERT INTO `configuracion` (`id`, `local_abierto`, `costo_envio`) VALUES
(1, 1, 1000);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `novedades`
--

CREATE TABLE `novedades` (
  `id` int(10) UNSIGNED NOT NULL,
  `tipo` enum('oferta','combo','plato_del_dia') NOT NULL,
  `titulo` varchar(120) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `imagen_url` varchar(500) DEFAULT NULL,
  `imagen_id` varchar(200) DEFAULT NULL,
  `creada_en` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `novedades`
--

INSERT INTO `novedades` (`id`, `tipo`, `titulo`, `descripcion`, `imagen_url`, `imagen_id`, `creada_en`) VALUES
(1, 'combo', 'Combo de prueba', 'Hamburguesa completa más gaseosa', NULL, NULL, '2026-10-17 15:09:14'),
(2, 'plato_del_dia', 'Plato del día de prueba', 'Texto de ejemplo para probar la pantalla de novedades', NULL, NULL, '2026-10-17 15:09:14'),
(3, 'oferta', 'Descuento en Carnicería', 'Vacío de exportación a 50%OFF a partir de 3Kg', NULL, NULL, '2026-10-23 16:38:17'),
(4, 'plato_del_dia', 'Nuevo plato disponible solo por hoy', 'El día 29 de octubre ven a probar nuestro guiso de carne de buddito solución', NULL, NULL, '2026-10-23 16:38:17');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `id` int(10) UNSIGNED NOT NULL,
  `codigo` varchar(12) NOT NULL,
  `nombre_cliente` varchar(120) NOT NULL,
  `tipo_entrega` enum('retiro','delivery') NOT NULL,
  `costo_envio` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `metodo_pago` varchar(30) NOT NULL,
  `total` int(10) UNSIGNED NOT NULL,
  `estado` enum('pendiente','confirmado') NOT NULL DEFAULT 'pendiente',
  `creado_en` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `pedidos`
--

INSERT INTO `pedidos` (`id`, `codigo`, `nombre_cliente`, `tipo_entrega`, `costo_envio`, `metodo_pago`, `total`, `estado`, `creado_en`) VALUES
(1, 'YMFA5P', 'Eliana Antonela Acuña', 'delivery', 1000, 'transferencia', 35500, 'pendiente', '2026-10-28 18:57:08'),
(2, 'X7DH44', 'Eliana Antonela Acuña', 'retiro', 0, 'efectivo', 42500, 'pendiente', '2026-10-28 18:59:45');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedido_items`
--

CREATE TABLE `pedido_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `pedido_id` int(10) UNSIGNED NOT NULL,
  `plato_id` int(10) UNSIGNED DEFAULT NULL,
  `nombre_plato` varchar(120) NOT NULL,
  `variante` varchar(80) DEFAULT NULL,
  `precio_unitario` int(10) UNSIGNED NOT NULL,
  `cantidad` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `pedido_items`
--

INSERT INTO `pedido_items` (`id`, `pedido_id`, `plato_id`, `nombre_plato`, `variante`, `precio_unitario`, `cantidad`) VALUES
(1, 1, 1, 'Hamburguesa completa', NULL, 6000, 2),
(2, 1, 7, 'Napolitana', NULL, 10000, 1),
(3, 1, 3, 'Empanadas de carne', 'Docena', 9500, 1),
(4, 1, 4, 'Gaseosa 1,5 L', NULL, 3000, 1),
(5, 2, 1, 'Hamburguesa completa', NULL, 6000, 2),
(6, 2, 7, 'Napolitana', NULL, 10000, 1),
(7, 2, 3, 'Empanadas de carne', 'Docena', 9500, 1),
(8, 2, 3, 'Empanadas de carne', 'Media docena', 5000, 1),
(9, 2, 4, 'Gaseosa 1,5 L', NULL, 3000, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `platos`
--

CREATE TABLE `platos` (
  `id` int(10) UNSIGNED NOT NULL,
  `categoria_id` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio` int(10) UNSIGNED DEFAULT NULL,
  `imagen_url` varchar(500) DEFAULT NULL,
  `imagen_id` varchar(200) DEFAULT NULL,
  `disponible` tinyint(1) NOT NULL DEFAULT 1,
  `orden` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `platos`
--

INSERT INTO `platos` (`id`, `categoria_id`, `nombre`, `descripcion`, `precio`, `imagen_url`, `imagen_id`, `disponible`, `orden`) VALUES
(1, 1, 'Hamburguesa completa', 'Carne, lechuga, tomate, jamón, queso y huevo', 6000, NULL, NULL, 1, 1),
(2, 1, 'Hamburguesa simple', 'Carne, lechuga y tomate', 4500, NULL, NULL, 1, 2),
(3, 2, 'Empanadas de carne', 'Cortadas a cuchillo', NULL, NULL, NULL, 1, 1),
(4, 3, 'Gaseosa 1,5 L', NULL, 3000, NULL, NULL, 1, 1),
(5, 3, 'Agua mineral', NULL, 1500, NULL, NULL, 0, 2),
(6, 4, 'Muzzarella', 'Salsa napolitana, queso muzzarella y orégano', 8000, NULL, NULL, 1, 1),
(7, 4, 'Napolitana', 'Salsa napolitana, queso muzzarella, orégano, aceitunas, tomate y huevo picado', 10000, NULL, NULL, 1, 2),
(8, 4, 'Calabresa', 'Salsa napolitana, queso muzzarella, orégano, aceitunas, calabresa', 10000, NULL, NULL, 1, 4),
(9, 4, 'Jamón y queso', 'Salsa napolitana, queso muzzarella, orégano, jamón cocido, aceitunas', 11000, NULL, NULL, 1, 3),
(10, 2, 'Empanadas de dinosaurio', 'Carne de tyranosaurio rex, huevos de velociraptor, especies del cretáceo ', 30000, NULL, NULL, 0, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(10) UNSIGNED NOT NULL,
  `usuario` varchar(60) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `creado_en` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `variantes`
--

CREATE TABLE `variantes` (
  `id` int(10) UNSIGNED NOT NULL,
  `plato_id` int(10) UNSIGNED NOT NULL,
  `nombre` varchar(80) NOT NULL,
  `precio` int(10) UNSIGNED NOT NULL,
  `orden` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `variantes`
--

INSERT INTO `variantes` (`id`, `plato_id`, `nombre`, `precio`, `orden`) VALUES
(1, 3, 'Media docena', 5000, 1),
(2, 3, 'Docena', 9500, 2),
(3, 10, 'Docena', 30000, 1),
(4, 10, 'Media docena', 16500, 2);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `configuracion`
--
ALTER TABLE `configuracion`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `novedades`
--
ALTER TABLE `novedades`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pedidos_estado_fecha` (`estado`,`creado_en`),
  ADD KEY `idx_pedidos_codigo` (`codigo`);

--
-- Indices de la tabla `pedido_items`
--
ALTER TABLE `pedido_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_items_pedido` (`pedido_id`),
  ADD KEY `fk_items_plato` (`plato_id`);

--
-- Indices de la tabla `platos`
--
ALTER TABLE `platos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_platos_categoria` (`categoria_id`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_usuarios_usuario` (`usuario`);

--
-- Indices de la tabla `variantes`
--
ALTER TABLE `variantes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_variantes_plato` (`plato_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `novedades`
--
ALTER TABLE `novedades`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `pedido_items`
--
ALTER TABLE `pedido_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `platos`
--
ALTER TABLE `platos`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `variantes`
--
ALTER TABLE `variantes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `pedido_items`
--
ALTER TABLE `pedido_items`
  ADD CONSTRAINT `fk_items_pedido` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_items_plato` FOREIGN KEY (`plato_id`) REFERENCES `platos` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `platos`
--
ALTER TABLE `platos`
  ADD CONSTRAINT `fk_platos_categoria` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`);

--
-- Filtros para la tabla `variantes`
--
ALTER TABLE `variantes`
  ADD CONSTRAINT `fk_variantes_plato` FOREIGN KEY (`plato_id`) REFERENCES `platos` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
