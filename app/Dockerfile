FROM python:3.11-slim

WORKDIR /app

# install requests library
RUN pip install --no-cache-dir requests

COPY app.py .

CMD ["python", "app.py"]