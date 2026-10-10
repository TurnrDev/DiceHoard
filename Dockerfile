# syntax=docker/dockerfile:1

# Build from this checkout. Production must include this fork's migrations and
# library-import fixes, rather than cloning upstream DiceCloud.
#
# Meteor 2.16 is intentionally retained for now. The current Vue/Atmosphere
# packages cannot resolve against Meteor 3.3; see docs/build-performance.md.
FROM node:14-bullseye AS dependencies

# The official Node builder image already contains curl and the native-module
# build toolchain. Avoid an apt upgrade here: Node 14's Bullseye base is old
# enough that mirror transitions can make an otherwise unnecessary install
# fail with transient 404s.

RUN useradd --create-home --shell /bin/bash meteor
USER meteor
WORKDIR /home/meteor/app

# Keep dependency metadata in a separate layer. Source-only edits now reuse
# this expensive install layer during normal Docker builds.
COPY --chown=meteor:meteor app/package.json app/package-lock.json ./
COPY --chown=meteor:meteor app/.meteor/ .meteor/

RUN curl -fsSL https://install.meteor.com/ | sh
ENV PATH=/home/meteor/.meteor:${PATH}

# Meteor manages the npm version compatible with this older application.
# BuildKit also retains downloaded packages when metadata changes.
RUN --mount=type=cache,id=dicehoard-meteor-npm,target=/home/meteor/.npm,uid=1001,gid=1001 \
    meteor npm install

FROM dependencies AS builder

# Copy source only after installing dependencies so ordinary app edits do not
# invalidate the dependency layer above.
COPY --chown=meteor:meteor app/ ./
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
RUN --mount=type=cache,target=/root/.npm npm install
WORKDIR /opt/dicehoard

EXPOSE 3000
CMD ["sh", "-c", "export CONTAINER_VERSION=\"$${CONTAINER_VERSION:-$$(cat /opt/dicehoard/CONTAINER_VERSION)}\"; exec node main.js"]
