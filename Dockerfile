FROM node:lts-alpine as build-stage
WORKDIR /app
COPY package*.json ./
RUN apk add --update npm
RUN npm install @vue/cli@3.7.0 -g
RUN npm install
COPY . /app
RUN npm run build

FROM nginx:stable-alpine as production-stage

COPY --from=build-stage . /usr/share/nginx/html
RUN rm /etc/nginx/conf.d/default.conf
COPY ./nginx/conf.d/ /etc/nginx/conf.d

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]