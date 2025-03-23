FROM python:3.12

WORKDIR /app
COPY ingest_location_data.py ingest_location_data.py
COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

ENTRYPOINT ["python", "ingest_location_data.py"]