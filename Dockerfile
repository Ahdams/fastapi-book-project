# Stage 1: Builder

FROM python:3.13-slim AS builder

# Set working directory
WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y build-essential && rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY requirements.txt .

# Install Python dependencies system-wide
RUN pip install --no-cache-dir -r requirements.txt


# Stage 2: Final image

FROM python:3.11-slim

# Create a non-root user
RUN useradd -m fastapiuser

# Set working directory
WORKDIR /app

# Copy installed Python packages from builder stage
COPY --from=builder /usr/local /usr/local

# Copy app source code
COPY . .

# Expose FastAPI port
EXPOSE 8000

# Switch to non-root user
USER fastapiuser

# Run FastAPI using uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
