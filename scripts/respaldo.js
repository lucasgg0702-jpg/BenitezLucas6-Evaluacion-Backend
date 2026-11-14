import 'dotenv/config'
import { mkdir, writeFile } from 'node:fs/promises'
import mysql from 'mysql2/promise'

// Guarda una copia de toda la base en respaldos/respaldo-<fecha>.sql
// Uso: node scripts/respaldo.js
const url = process.env.DATABASE_URL_PUBLICA
if (!url) {
  console.error('Falta la variable de entorno DATABASE_URL_PUBLICA')
  process.exit(1)
}

const FILAS_POR_INSERT = 100

const conexion = await mysql.createConnection({
  uri: url,
  dateStrings: true,
  supportBigNumbers: true,
  bigNumberStrings: true,
})

// Convierte un valor de la base en texto SQL seguro
const valorSql = (valor) => {
  if (valor !== null && typeof valor === 'object' && !Buffer.isBuffer(valor)) {
    return conexion.escape(JSON.stringify(valor))
  }
  return conexion.escape(valor)
}

try {
  await conexion.query("SET time_zone = '+00:00'")

  const salida = [
    `-- Respaldo generado el ${new Date().toISOString()}`,
    'SET NAMES utf8mb4;',
    "SET time_zone = '+00:00';",
    'SET FOREIGN_KEY_CHECKS = 0;',
  ]
  const resumen = []

  const [tablas] = await conexion.query(
    "SHOW FULL TABLES WHERE Table_type = 'BASE TABLE'",
  )
  const nombres = tablas.map((fila) => Object.values(fila)[0])

  for (const tabla of nombres) {
    const id = conexion.escapeId(tabla)
    const [[creacion]] = await conexion.query(`SHOW CREATE TABLE ${id}`)
    const [filas] = await conexion.query(`SELECT * FROM ${id}`)

    salida.push(`\n-- Tabla ${tabla} (${filas.length} filas)`)
    salida.push(`DROP TABLE IF EXISTS ${id};`)
    salida.push(`${creacion['Create Table']};`)

    if (filas.length > 0) {
      const columnas = Object.keys(filas[0])
        .map((columna) => conexion.escapeId(columna))
        .join(', ')

      for (let i = 0; i < filas.length; i += FILAS_POR_INSERT) {
        const grupo = filas
          .slice(i, i + FILAS_POR_INSERT)
          .map((fila) => `(${Object.values(fila).map(valorSql).join(', ')})`)
          .join(',\n')
        salida.push(`INSERT INTO ${id} (${columnas}) VALUES\n${grupo};`)
      }
    }

    resumen.push(`  ${tabla}: ${filas.length} filas`)
  }

  salida.push('\nSET FOREIGN_KEY_CHECKS = 1;')

  const marca = new Date().toISOString().slice(0, 16).replace('T', '-').replace(':', '')
  const archivo = `respaldos/respaldo-${marca}.sql`
  await mkdir('respaldos', { recursive: true })
  await writeFile(archivo, `${salida.join('\n')}\n`, 'utf8')

  console.log(`Listo: respaldo guardado en ${archivo}`)
  console.log(resumen.join('\n'))
} catch (error) {
  console.error('No se pudo hacer el respaldo:', error.message)
  process.exitCode = 1
} finally {
  await conexion.end()
}