# ============================================
# finNow Backend - NestJS with TypeScript
# Multi-stage build for optimized production image (YARN VERSION)
# ============================================

# ============================================
# Stage 1: Development Dependencies
# ============================================
FROM node:24-alpine AS development

WORKDIR /usr/src/app

RUN apk add --no-cache python3 make g++ openssl

COPY package.json yarn.lock ./
COPY tsconfig*.json ./
COPY nest-cli.json ./

COPY prisma ./prisma
RUN yarn install --frozen-lockfile
RUN npx prisma generate

COPY src ./src

EXPOSE 3000

CMD ["yarn", "start:dev"]

# ============================================
# Stage 2: Build Stage
# ============================================
FROM node:20-alpine AS build

WORKDIR /usr/src/app

RUN apk add --no-cache python3 make g++

# Copia os arquivos de configuração
COPY package.json yarn.lock ./
COPY tsconfig*.json ./
COPY nest-cli.json ./

# Instala TODAS as dependências (incluindo devDependencies) para fazer o build
RUN yarn install --frozen-lockfile

COPY src ./src

# 4. Build com yarn
RUN yarn build

# 5. Limpeza (Prune) com Yarn
# O yarn instala apenas dependências de produção sobre a pasta existente,
# removendo as devDependencies desnecessárias para a imagem final.
RUN yarn install --production --ignore-scripts --prefer-offline

# ============================================
# Stage 3: Production Stage
# ============================================
FROM node:20-alpine AS production

RUN addgroup -g 1001 -S nodejs && \
  adduser -S nestjs -u 1001

WORKDIR /usr/src/app

# Copia apenas o node_modules já limpo e o dist
COPY --from=build --chown=nestjs:nodejs /usr/src/app/node_modules ./node_modules
COPY --from=build --chown=nestjs:nodejs /usr/src/app/dist ./dist
COPY --from=build --chown=nestjs:nodejs /usr/src/app/package.json ./

USER nestjs

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# O comando final continua sendo node direto, pois é mais leve que rodar via yarn start
CMD ["node", "dist/main"]