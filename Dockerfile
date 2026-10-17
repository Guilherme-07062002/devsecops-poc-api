# Imagem base minimalista (Alpine)
FROM node:20-alpine AS builder
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN corepack enable && pnpm install --frozen-lockfile --prod

FROM node:20-alpine AS runner
WORKDIR /app

# Criar e utilizar usuário não-root por segurança
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

COPY --chown=appuser:appgroup --from=builder /app/node_modules ./node_modules
COPY --chown=appuser:appgroup src/ ./src

EXPOSE 3000
CMD ["node", "src/app.js"]