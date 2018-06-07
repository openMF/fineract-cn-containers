#!/bin/sh

while ! nc -z 172.16.238.5 9042; do
  echo "Cassandra is unavailable - sleeping"
  sleep 1
done
echo "Cassandra is up - executing command"
