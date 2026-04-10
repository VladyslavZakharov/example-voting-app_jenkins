#!/bin/bash

set -e

# Python static check (vote)
echo "Running flake8 for vote service..."
docker run --rm -v "$(pwd)/vote:/app" -w /app python:3.11-slim bash -lc "pip install --no-cache-dir flake8 && flake8 ."

# Node.js static check (result)
echo "Running eslint for result service..."
docker run --rm -v "$(pwd)/result:/app" -w /app node:20 bash -lc "npm install --no-save eslint && find . -type f -name '*.js' ! -path './node_modules/*' -print0 | xargs -0 -r node ./node_modules/eslint/bin/eslint.js -c eslint.config.mjs"

# .NET static check (worker)
echo "Running dotnet format for worker service..."
docker run --rm -v "$(pwd)/worker:/src" -w /src mcr.microsoft.com/dotnet/sdk:8.0 dotnet format --verify-no-changes --severity error

echo "All static checks completed."