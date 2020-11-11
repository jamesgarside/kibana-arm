FROM ubuntu:latest
WORKDIR /root

RUN apt update -y && apt install wget -y && apt-get install xz-utils -y && apt-get install curl -y

# Download & Install official Kibana package
RUN wget https://artifacts.elastic.co/downloads/kibana/kibana-7.9.3-amd64.deb
RUN dpkg -i --force-all kibana-7.9.3-amd64.deb

# Remove packaged Node version
RUN rm -rf /usr/share/kibana/node
RUN mkdir /usr/share/kibana/node

# Download & Extract compatiable Node version
RUN wget https://nodejs.org/download/release/v10.22.1/node-v10.22.1-linux-arm64.tar.xz
RUN tar -xJvf node-v10.22.1-linux-arm64.tar.xz

# Move new Node version to Kibana directory
RUN mv ./node-v10.*/* /usr/share/kibana/node
RUN ln -s /usr/share/kibana/node/bin/node /usr/bin/node
RUN ln -s /usr/share/kibana/node/bin/npm /usr/bin/npm
RUN ln -s /usr/share/kibana/node/bin/npx /usr/bin/npx

EXPOSE 5601
COPY kibana.yml /usr/share/kibana/config/kibana.yml

CMD ["/usr/share/kibana/bin/kibana","--allow-root", "-c", "usr/share/kibana/config/kibana.yml"]