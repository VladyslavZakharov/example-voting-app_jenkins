#!/bin/bash
set -euo pipefail

# Python static check (vote)
echo "Running flake8 for vote service..."
tar -C vote -cf - . | docker run --rm -i python:3.11-slim bash -lc '
  mkdir -p /app &&
  tar -xf - -C /app &&
  cd /app &&
  pip install --no-cache-dir flake8 &&
  flake8 .
'

# Node.js static check (result)
echo "Running eslint for result service..."
tar -C result -cf - . | docker run --rm -i node:20 bash -lc '
  mkdir -p /app &&
  tar -xf - -C /app &&
  cd /app &&
  npm install --no-save eslint &&
  node ./node_modules/eslint/bin/eslint.js -c eslint.config.mjs server.js
'

# .NET static check (worker)
echo "Running dotnet format for worker service..."
tar -C worker -cf - . | docker run --rm -i mcr.microsoft.com/dotnet/sdk:8.0 bash -lc '
  mkdir -p /src &&
  tar -xf - -C /src &&
  cd /src &&
  dotnet format ./Worker.csproj --verify-no-changes --severity error
'

echo "All static checks completed."