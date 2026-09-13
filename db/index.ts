import { neon } from '@neondatabase/serverless'
import { drizzle } from 'drizzle-orm/neon-http'
import * as schema from './schema.js'

// Works with any Neon connection string — Netlify Database (once "claimed"
// into your own Neon account), a fresh free Neon project, or any other
// Neon Postgres. Not tied to any specific hosting platform.
const sql = neon(process.env.DATABASE_URL!)
export const db = drizzle({ client: sql, schema })
