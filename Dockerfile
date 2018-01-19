#
# ---- Base Node ----
FROM mhart/alpine-node:8
# set working directory
WORKDIR /app
# copy project file
COPY package.json .
COPY package-lock.json .

#
# ---- Dependencies ----
RUN npm set progress=false && npm config set depth 0
COPY .env .
COPY .npmrc .
RUN eval $(egrep -v '^#' .env | xargs) npm i
RUN rm .npmrc

#
# ---- Build Frontend Client ----
COPY ./server ./server
COPY ./client ./client
COPY ./browserify ./browserify
RUN npm run build:client

# Run the image as a non-root user
RUN adduser -D myuser
USER myuser

CMD npm start
