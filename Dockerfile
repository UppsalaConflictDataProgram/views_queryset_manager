FROM curlimages/curl:latest as fetch-cert
USER root
RUN curl https://cacerts.digicert.com/DigiCertGlobalRootG2.crt.pem --output /root.crt

FROM python:3.8
COPY ./requirements.txt /
RUN pip install -r requirements.txt 
COPY --from=fetch-cert /root.crt /.postgresql/root.crt
COPY ./query-set-manager/* /
CMD ["gunicorn","-k","uvicorn.workers.UvicornWorker","--bind","0.0.0.0:80","app:app"]
