# Build Stage
FROM node:20-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

# ✅ WICHTIG: FIX für OpenSSL + React
ENV NODE_OPTIONS=--openssl-legacy-provider
ENV CI=false

RUN npm run build

# Production Stage
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]