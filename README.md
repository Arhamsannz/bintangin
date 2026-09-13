# BINTANGIN

BINTANGIN is a dynamic QR/NFC system for printed business cards used to collect customer feedback. Each card carries a permanent QR code (e.g. `/q/BGN0001`). Before activation, scanning it opens an activation form; after activation, the same QR opens a star-rating page: a 1–3 star rating routes the customer to a WhatsApp feedback message (pre-filled with the rating given), while a 4–5 star rating redirects straight to the shop's Google Review link. Both destinations are stored per card and editable from `/admin` without reprinting the card.

## Key technologies

- **TanStack Start** (React 19, TanStack Router v1) — file-based routing, SSR
- **Vite 7** — build tooling
- **Tailwind CSS 4** — styling, mobile-first
- **Neon Postgres** (via `@neondatabase/serverless` + `drizzle-orm/neon-http`) + **Drizzle ORM** — persistent storage for cards and scans, reachable from any host via `DATABASE_URL`
- **qrcode** — QR generation (high error correction, black/white, no logo)
- **jszip** — bulk ZIP download of generated QR codes
- Hosting is host-agnostic — deploy the standard Node output (`pnpm build` then `pnpm start`) to whichever platform you choose

## What's live now

- `/` — landing page
- `/q/$code` — activation form (unactivated cards) or the star-rating flow (activated cards: 1–3 stars → WhatsApp feedback, 4–5 stars → Google Review), with a "card not found" state. Activation, and every subsequent visit, is backed by the database — refreshing or opening the same URL from another device shows the same state.
- `/admin` — dashboard with card counts, searchable card table (activate/edit/deactivate), and a fully working bulk QR generator (PNG, SVG, and ZIP download, real QR images pointing at `/q/<code>`). Generating QR codes also creates the matching `INACTIVE` rows in the database.

All card data is read and written through server functions in `src/server/cards.functions.ts`, backed by the `cards` and `scans` tables defined in `db/schema.ts`. `src/data/cards.ts` is kept only as demo/seed fixture data and is not read by any route.

## Running locally

```bash
pnpm install
pnpm dev
```

Visit `http://localhost:3000`.

Create a `.env` file (see `.env.example`) with `DATABASE_URL` pointing at your Neon database and `ADMIN_PASSWORD` set, or the persistence and `/admin` login features won't work.

## Database

Schema lives in `db/schema.ts`; SQL migrations are generated into `netlify/database/migrations/` (folder name is legacy, just SQL files now) with `npx drizzle-kit generate --name <name>`. Nothing applies them automatically anymore — run `npx drizzle-kit migrate` yourself (with `DATABASE_URL` set) after generating a migration and whenever you deploy schema changes to a new environment. See `.env.example` for the environment variables involved.

