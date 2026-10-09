#!/usr/bin/env bash
set -euo pipefail

# Meteor uses Mongo's oplog to distribute changes efficiently. This only runs
# on the first creation of the persistent Mongo volume.
mongosh --quiet --eval '
  try {
    rs.status();
  } catch (error) {
    rs.initiate({ _id: "rs0", members: [{ _id: 0, host: "db:27017" }] });
  }
'
