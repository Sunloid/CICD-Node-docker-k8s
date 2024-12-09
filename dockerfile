FROM node:16 AS build
WORKDIR /app
COPY package.json ./
RUN npm install
COPY app.js .
EXPOSE 3000
CMD ["npm", "start"]

