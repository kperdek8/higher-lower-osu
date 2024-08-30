# Use the official Elixir image
FROM elixir:1.17-slim

# Install PostgreSQL client
RUN apt-get update && apt-get install -y \
    build-essential \
    inotify-tools \
    nodejs \
    npm \
    git \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV MIX_ENV=dev
ENV PORT=4000

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set up the working directory
WORKDIR /app
COPY . .

# Cache and install dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get
RUN mix deps.compile

# Install esbuild
RUN mix esbuild.install

# Ensure entrypoint script has executable permissions
RUN chmod +x /app/entrypoint.sh

# Move init.sql to the correct location if needed
RUN mkdir -p /docker-entrypoint-initdb.d && cp /app/init.sql /docker-entrypoint-initdb.d/

# Expose the port the app runs on
EXPOSE 4000

# Set the entrypoint script
ENTRYPOINT ["/app/entrypoint.sh"]