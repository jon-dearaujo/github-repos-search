FROM node:10.16.0-alpine

RUN mkdir /app
WORKDIR /app
COPY . /app
RUN chmod +x ./start.sh

VOLUME /app

CMD [ "run", "dev" ]
ENTRYPOINT [ "./start.sh" ]