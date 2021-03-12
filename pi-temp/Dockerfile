FROM node:current-alpine AS dependencies
WORKDIR /app
RUN npm install --save express && \
    npm install --save express-prettify && \
    npm install --save moment && \
    npm install --save request && \
    npm install --save request-promise

FROM node:current-alpine
WORKDIR /app
COPY --from=dependencies /app/package*.json ./
COPY *.js .
RUN npm install --production
EXPOSE 5000
CMD ["node", "TemperatureAgent.js"]