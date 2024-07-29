FROM node:14.15.0-alpine
RUN apk add --no-cache python2 g++ make
WORKDIR /app
COPY ./package.json .
RUN npm install
COPY . .
RUN yarn install --production
CMD ["node", "index.js"]
EXPOSE 3000