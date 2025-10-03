# # Use official Python 3.11.13 slim image
# FROM python:3.11.13-slim

# # Set environment variables
# ENV PYTHONDONTWRITEBYTECODE=1 \
#     PYTHONUNBUFFERED=1 \
#     PIP_NO_CACHE_DIR=1 \
#     PIP_DISABLE_PIP_VERSION_CHECK=1 \
#     PIP_DEFAULT_TIMEOUT=100

# # Install system dependencies (optional: add more if your app needs)
# RUN apt-get update

# # Set work directory
# WORKDIR /app

# # Copy requirements first for caching
# COPY requirements.txt .

# # Install Python dependencies
# RUN pip install --upgrade pip \
#     && pip install -r requirements.txt

# ENV HOME=/app

# RUN mkdir -p /app/.streamlit && chmod -R 777 /app/.streamlit

# # Copy application code
# COPY . .

# # Expose Streamlit port
# EXPOSE 7860

# # Streamlit specific environment variables
# ENV STREAMLIT_SERVER_HEADLESS=true \
#     STREAMLIT_SERVER_PORT=7860 \
#     STREAMLIT_SERVER_ENABLECORS=false \
#     STREAMLIT_SERVER_ENABLEXSRSFPROTECTION=false \
#     STREAMLIT_BROWSER_GATHERUSAGESTATS=false


# # Command to run the app
# CMD ["streamlit", "run", "src/main.py", "--server.port=7860", "--server.address=0.0.0.0"]



# Use official Python 3.11 slim image
FROM python:3.11.13-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_DEFAULT_TIMEOUT=100

# Install system dependencies (adjust if needed for Camelot etc.)
RUN apt-get update
    # && apt-get install -y --no-install-recommends \
    # build-essential \
    # ghostscript \
    # python3-tk \
    # tcl \
    # tk \
    # libglib2.0-0 \
    # libsm6 \
    # libxext6 \
    # libxrender1 \
    # poppler-utils \
    # && rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /app

# Copy requirements first for caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# Create a non-root user and give ownership of /app
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

# Environment configs for Streamlit
ENV HOME=/app \
    STREAMLIT_SERVER_HEADLESS=true \
    STREAMLIT_SERVER_PORT=7860 \
    STREAMLIT_SERVER_ENABLECORS=false \
    STREAMLIT_SERVER_ENABLE_XSRF_PROTECTION=false \
    STREAMLIT_SERVER_MAXUPLOADSIZE=200 \
    STREAMLIT_BROWSER_GATHERUSAGESTATS=false \
    STREAMLIT_CONFIG_DIR=/tmp/.streamlit

# Make sure config dir exists
RUN mkdir -p /tmp/.streamlit

# Copy application code
COPY --chown=appuser:appuser . .

# Expose Streamlit port
EXPOSE 7860

# Command to run the app
CMD ["streamlit", "run", "src/main.py", "--server.port=7860", "--server.address=0.0.0.0"]
