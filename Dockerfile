# ============================
# STAGE 1: Builder
# ============================
FROM python:3.12-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

COPY requirements.txt .

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential curl ca-certificates \
    && python -m pip install --upgrade pip \
    && pip install --user --no-cache-dir -r requirements.txt \
    && rm -rf /var/lib/apt/lists/*

# ============================
# STAGE 2: Runtime
# ============================
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8000
# Create non-root user
RUN groupadd --system appgroup && useradd --system --gid appgroup --uid 1000 --home /home/appuser appuser

WORKDIR /app

# Copy Python packages from builder to user's local directory
COPY --from=builder /root/.local /home/appuser/.local

# Set PATH for the non-root user
ENV PATH=/home/appuser/.local/bin:$PATH

# Copy application code
COPY . .

# Ensure app files are owned by non-root user
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

EXPOSE 8000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://127.0.0.1:8000/healthcheck || exit 1

# Production entry: UvicornWorker
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
