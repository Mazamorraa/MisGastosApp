#!/usr/bin/env bash
# wait-for-it.sh

host="$1"
port="$2"
shift 2
cmd="$@"

until nc -z "$host" "$port"; do
  echo "⏳ Waiting for $host:$port..."
  sleep 1
done

echo "✅ $host:$port is available. Executing command..."
exec $cmd