-- DATOS DE PRUEBA: solo para desarrollo, no son el menú real del local.
-- Ejecutar una sola vez sobre la base vacía.

USE lo_de_chicho;

INSERT INTO categorias (id, nombre, orden) VALUES
  (1, 'Hamburguesas', 1),
  (2, 'Empanadas', 2),
  (3, 'Bebidas', 3);

INSERT INTO platos (id, categoria_id, nombre, descripcion, precio, disponible, orden) VALUES
  (1, 1, 'Hamburguesa completa', 'Carne, lechuga, tomate, jamón, queso y huevo', 6000, 1, 1),
  (2, 1, 'Hamburguesa simple', 'Carne, lechuga y tomate', 4500, 1, 2),
  (3, 2, 'Empanadas de carne', 'Cortadas a cuchillo', NULL, 1, 1),
  (4, 3, 'Gaseosa 1,5 L', NULL, 3000, 1, 1),
  (5, 3, 'Agua mineral', NULL, 1500, 0, 2);

INSERT INTO variantes (plato_id, nombre, precio, orden) VALUES
  (3, 'Media docena', 5000, 1),
  (3, 'Docena', 9500, 2);

INSERT INTO novedades (tipo, titulo, descripcion) VALUES
  ('combo', 'Combo de prueba', 'Hamburguesa completa más gaseosa'),
  ('plato_del_dia', 'Plato del día de prueba', 'Texto de ejemplo para probar la pantalla de novedades');
