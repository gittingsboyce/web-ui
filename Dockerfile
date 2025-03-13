FROM mcr.microsoft.com/playwright/python:latest

WORKDIR /app

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=0

# Create browser directories and set permissions
RUN mkdir -p /ms-playwright && \
    mkdir -p /opt/render/.cache/ms-playwright && \
    chmod -R 777 /ms-playwright && \
    chmod -R 777 /opt/render/.cache/ms-playwright

# Make port configurable via environment variable
ENV PORT=7788

# Run the application with Playwright install and proper permissions
CMD python -m playwright install --with-deps && \
    chmod -R 777 /opt/render/.cache/ms-playwright && \
    python webui.py --ip 0.0.0.0 --port $PORT --headless true
