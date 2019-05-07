FROM python:3-slim

RUN apt-get update -qq && apt-get install -y git build-essential gcc pandoc
RUN pip install --upgrade pip

RUN pip install pandoc
RUN pip wheel --wheel-dir=/tmp/yara-python --build-option="build" --build-option="--enable-dex" git+https://github.com/VirusTotal/yara-python.git@v3.10.0 ;
RUN pip install --no-index --find-links=/tmp/yara-python yara-python
RUN rm -rf /tmp/yara-python

RUN mkdir /apkid
WORKDIR /apkid
COPY . .

RUN python prep-release.py
RUN pip install -e .[dev]

# Place to bind a mount point to for scratch pad work
RUN mkdir /input
WORKDIR /input

ENTRYPOINT ["apkid"]
