#!/bin/sh
chown -R minecraft:minecraft /papermc
exec su-exec minecraft "$@"