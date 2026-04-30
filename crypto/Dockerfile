FROM python:3.12-slim
WORKDIR /app
RUN pip install cryptography flask
COPY app.py .
CMD ["python", "app.py"]

