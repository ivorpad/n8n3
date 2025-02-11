FROM n8nio/n8n:latest

ARG PGPASSWORD
ARG PGHOST
ARG PGPORT
ARG PGDATABASE
ARG PGUSER

ENV DB_TYPE=postgresdb
ENV DB_POSTGRESDB_DATABASE=$PGDATABASE
ENV DB_POSTGRESDB_HOST=$PGHOST
ENV DB_POSTGRESDB_PORT=$PGPORT
ENV DB_POSTGRESDB_USER=$PGUSER
ENV DB_POSTGRESDB_PASSWORD=$PGPASSWORD

USER root
# Install packages in the correct n8n location
WORKDIR /usr/local/lib/node_modules/n8n
RUN mkdir -p node_modules && \
    npm install --save axios moment lodash @types/axios @types/lodash && \
    chown -R node:node .
WORKDIR /data
USER node

ARG ENCRYPTION_KEY

ENV N8N_ENCRYPTION_KEY=$ENCRYPTION_KEY
ENV NODE_FUNCTION_ALLOW_EXTERNAL=axios,moment,lodash
ENV N8N_NODES_INCLUDE_MODE=all
ENV N8N_NODES_EXCLUDE_MODE=none

CMD ["n8n", "start"]
