# setup only
FROM node:lts-alpine3.16 as base
RUN apk update
WORKDIR /app
COPY ./app/package.json /app/package.json
COPY ./app/yarn.lock /app/yarn.lock
RUN apk add --upgrade tini && \
    yarn install
COPY ./app/* /app/

#EXPOSE 3000
#RUN yarn install
#USER node
#ENTRYPOINT ["/sbin/tini", "--"]
#CMD ["/bin/sh"]

FROM node:lts-alpine3.16 as setup
COPY --from=base --chown=node:node /app /app

WORKDIR /app
USER node



# run server and hot reload
FROM node:lts-alpine3.16 as dev
COPY --from=base /sbin/tini /sbin/tini
COPY --from=base --chown=node:node /app /app
WORKDIR /app
USER node
EXPOSE 3000
ENTRYPOINT [ "/sbin/tini", "--", "yarn" ]
CMD ["dev", "--force"]

# build development and production
FROM node:lts-alpine3.16 as prod
#COPY --from=base /app/node_modules /app/node_modules
#COPY --from=base /app/.nuxt /app/.nuxt
COPY --from=base --chown=node:node /app /app
WORKDIR /app
RUN yarn build

USER node
EXPOSE 3000
#RUN yarn install && \
#    apk add --upgrade tini
