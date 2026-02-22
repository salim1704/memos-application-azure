# Front-End Build
FROM node:22-alpine AS frontend-build
WORKDIR /app/web

COPY app/web/package.json app/web/pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install --no-optional && pnpm add -D @rollup/rollup-linux-x64-musl

COPY app/web/ ./
RUN pnpm run release

#Backend build
FROM golang:1.25-alpine AS backend-build
WORKDIR /app

COPY app/ ./
COPY --from=frontend-build /app/server/router/frontend/dist ./server/router/frontend/dist

RUN go build -o memos ./cmd/memos

# Run-app as non-root
FROM alpine:3.20
WORKDIR /app

RUN adduser -D -u 1000 user
COPY --from=backend-build /app/memos ./memos
RUN chown -R user:user /app && chmod 500 /app/memos

USER user
EXPOSE 8081
CMD ["./memos"]