FROM node:16.14
RUN apk add --no-cache python2 g++ make
WORKDIR /app
COPY ./package.json .
COPY . .
RUN yarn install --ignore-engines
CMD ["node", "src/index.js"]
EXPOSE 3000