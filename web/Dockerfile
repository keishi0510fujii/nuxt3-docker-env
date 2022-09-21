FROM nginx:1.22.0-alpine as base

RUN apk add --upgrade tini

COPY ./nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

FROM nginx:1.22.0-alpine as dev

COPY --from=base --chown=nginx:nginx /sbin/tini /sbin/tini
COPY --from=base --chown=nginx:nginx /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY --from=base --chown=nginx:nginx /etc/nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080

USER nginx

ENTRYPOINT ["/sbin/init", "--"]
CMD ["nginx"]