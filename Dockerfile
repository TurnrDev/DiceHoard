# Build from this checkout. Production must include this fork's migrations and
# library-import fixes, rather than cloning upstream DiceCloud.
FROM node:14-bullseye AS builder

# The official Node builder image already contains curl and the native-module
# build toolchain. Avoid an apt upgrade here: Node 14's Bullseye base is old
# enough that mirror transitions can make an otherwise unnecessary install
# fail with transient 404s.

RUN useradd --create-home --shell /bin/bash meteor
USER meteor
WORKDIR /home/meteor/app
COPY --chown=meteor:meteor app/ ./

RUN curl -fsSL https://install.meteor.com/ | sh
ENV PATH=/home/meteor/.meteor:${PATH}

# Meteor manages the npm version compatible with this older application.
# Keep these layers separate: package installation is cacheable, and Docker
# clearly reports whether a slow build is dependency setup or bundling.
RUN meteor npm install
RUN meteor build --directory /home/meteor/bundle --architecture os.linux.x86_64
RUN node -p "require('./package.json').version" > /home/meteor/CONTAINER_VERSION

FROM node:14-bullseye-slim

ENV NODE_ENV=production
WORKDIR /opt/dicehoard
COPY --from=builder /home/meteor/bundle/bundle/ ./
COPY --from=builder /home/meteor/CONTAINER_VERSION ./CONTAINER_VERSION

# Meteor writes its deployable Node package manifest here. Installing at the
# bundle root leaves runtime.js unable to resolve @meteorjs/reify.
WORKDIR /opt/dicehoard/programs/server
RUN npm install
WORKDIR /opt/dicehoard

EXPOSE 3000
CMD ["sh", "-c", "export CONTAINER_VERSION=\"$${CONTAINER_VERSION:-$$(cat /opt/dicehoard/CONTAINER_VERSION)}\"; exec node main.js"]
