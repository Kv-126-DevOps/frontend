FROM python:3.9-slim

RUN useradd serve

WORKDIR /home/serve

COPY --chown=kvuser:kvuser requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY  --chown=kvuser:kvuser app app
COPY  --chown=kvuser:kvuser frontend.py config.py ./

ENV FLASK_APP frontend.py

USER kvuser

EXPOSE 80

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
