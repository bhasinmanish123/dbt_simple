# ============================================================
# Dockerfile — runs dbt_simple inside a container
# Same idea as Helia's language: 'docker' approach
# ============================================================
FROM python:3.11-slim

# Set working directory inside the container
WORKDIR /dbt

# Install system dependencies (git is needed by dbt for deps)
RUN apt-get update && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

# Install dbt for Snowflake
RUN pip install --no-cache-dir dbt-snowflake

# Copy the whole dbt project into the image
COPY . /dbt

# Tell dbt where to find profiles.yml (project root)
ENV DBT_PROFILES_DIR=/dbt

# Default command when the container runs.
# Overridden at runtime (e.g. docker run ... dbt build --target dev)
CMD ["dbt", "build", "--target", "dev"]
