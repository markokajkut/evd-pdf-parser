# FROM python:3.13.5-slim

# WORKDIR /app

# RUN apt-get update && apt-get install -y \
#     build-essential \
#     curl \
#     git \
#     && rm -rf /var/lib/apt/lists/*

# COPY requirements.txt ./
# COPY src/ ./src/

# RUN pip3 install -r requirements.txt

# EXPOSE 8501

# HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health

# ENTRYPOINT ["streamlit", "run", "src/streamlit_app.py", "--server.port=8501", "--server.address=0.0.0.0"]


# Use official Python 3.11.13 slim image
FROM python:3.11.13-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_DEFAULT_TIMEOUT=100

# Install system dependencies (optional: add more if your app needs)
RUN apt-get update
    # && apt-get install -y --no-install-recommends \
    # build-essential \
    # curl \
    # libglib2.0-0 \
    # libsm6 \
    # libxext6 \
    # libxrender-dev \
    # && rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /app

# Copy requirements first for caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# Copy application code
COPY . .

# Expose Streamlit port
EXPOSE 8501

# Streamlit specific environment variables
ENV STREAMLIT_SERVER_HEADLESS=true \
    STREAMLIT_SERVER_PORT=8501 \
    STREAMLIT_SERVER_ENABLECORS=false \
    STREAMLIT_SERVER_ENABLEXSRSFPROTECTION=false

# Command to run the app
ENTRYPOINT ["streamlit", "run"]
CMD ["src/main.py"]
