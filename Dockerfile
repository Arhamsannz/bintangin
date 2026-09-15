FROM node:20-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

# Jalankan build
RUN npm run build

# --- TAMBAHAN DIAGNOSTIK ---
# Perintah ini akan mencetak isi folder ke log Railway agar kita tahu file jadinya di mana
RUN echo "=== ISI FOLDER UTAMA ===" && ls -la
RUN echo "=== ISI FOLDER .OUTPUT (JIKA ADA) ===" && ls -la .output || true
RUN echo "=== ISI FOLDER DIST (JIKA ADA) ===" && ls -la dist || true
# ---------------------------

ENV NODE_ENV=production
EXPOSE 3000

CMD ["node", ".output/server/index.mjs"]
