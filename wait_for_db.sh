#!/bin/sh

host="$1"
port="$2"
shift
shift
cmd="$@"

echo ${host} ${port}
while ! nc -z ${host} ${port}; do
    >&2 echo "Cassandra is unavailable - sleeping"
  sleep 1
done

>&2 echo "Cassandra is up - executing command"
exec $cmd