FROM node:14.15.0-alpine
RUN apk add --no-cache python2 g++ make
WORKDIR /app
COPY ./package.json .
COPY . .
RUN yarn install --production
CMD ["node", "src/index.js"]
EXPOSE 3000