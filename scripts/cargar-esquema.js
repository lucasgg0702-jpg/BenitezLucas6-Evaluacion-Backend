import 'dotenv/config'
import { readFile } from 'node:fs/promises'
import mysql from 'mysql2/promise'

// La URL de conexión llega por variable de entorno, nunca escrita en el código
const url = process.env.DATABASE_URL_PUBLICA
if (!url) {
  console.error('Falta la variable de entorno DATABASE_URL_PUBLICA')
  process.exit(1)
}

const archivo = process.argv[2] || 'sql/schema.sql'
const sql = await readFile(archivo, 'utf8')

const conexion = await mysql.createConnection({
  uri: url,
  multipleStatements: true,
})

try {
  await conexion.query(sql)
  console.log(`Listo: se ejecutó ${archivo}`)

  const [tablas] = await conexion.query('SHOW TABLES')
  const nombres = tablas.map((fila) => Object.values(fila)[0])
  console.log(`Tablas en la base: ${nombres.join(', ')}`)
} catch (error) {
  console.error('Error al ejecutar el archivo:', error.message)
  process.exitCode = 1
} finally {
  await conexion.end()
}