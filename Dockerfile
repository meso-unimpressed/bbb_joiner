FROM node:lts-alpine AS bundle-frontend
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install 
COPY postcss.config.js ./frontend/
COPY frontend ./frontend
COPY src/templates ./src/templates
RUN npm run build

FROM crystallang/crystal:0.34.0-alpine AS build
WORKDIR /app
COPY shard.yml shard.lock ./
RUN shards install --production
COPY Makefile ./
COPY src ./src
COPY --from=bundle-frontend /app/public ./public
RUN shards build --production --release --static

FROM scratch AS final-image
COPY --from=build /etc/ssl /etc/ssl
COPY --from=build /app/bin/bbb_joiner /usr/bin/bbb_joiner

CMD ["/usr/bin/bbb_joiner"]
