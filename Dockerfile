FROM node:lts-alpine

WORKDIR /app

# If the base package json changes then all of the below is rerun
COPY package*.json ./

COPY client/package*.json client/
RUN npm run install-client --omit=dev

COPY server/package*.json server/
RUN npm run install-server --omit=dev

# We are runing the build after npm intallations as the 
# installations need only package lock to change while
# the build needs to be build if any of the client file changes
COPY client/ client/
RUN npm run build --prefix client

COPY server/ server/

USER node

CMD ["npm", "start","--prefix","server"]

EXPOSE 8000