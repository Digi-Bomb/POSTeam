FROM python:3.11-slim
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app ./app

ENV PORT=12500 FLASK_ENV=development
EXPOSE 12500

CMD ["python", "-m", "app.main"]