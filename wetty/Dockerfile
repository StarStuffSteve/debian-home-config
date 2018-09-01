FROM node:0.10.38

ADD . /app
WORKDIR /app
RUN npm install

RUN apt update
RUN apt install -y vim
RUN useradd -d /home/itc -m -s /bin/bash itc
RUN echo 'itc:iwanttolearn' | chpasswd
RUN echo 'root:iwanttolearn' | chpasswd

EXPOSE 3000

ENTRYPOINT ["node"]
CMD ["app.js", "-p", "3000"]
