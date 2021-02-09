# Kibana builds for ARM
This repo will contain builds of Kibana for ARM. 

If the build you are looking for isn’t here please contact me.
Feel free to branch and update yourselves. 

## Docker Description
This a modified version of the Official Dockerfile found [here](https://github.com/elastic/dockerfiles/blob/7.9/kibana/Dockerfile)


## Docker Images
Pre-built docker images can be found on my Dockerhub [here](https://hub.docker.com/r/jamesgarside/kibana/).

- [Kibana 7.10.2](https://hub.docker.com/r/jamesgarside/kibana/tags)
- [Kibana 7.10.0](https://hub.docker.com/r/jamesgarside/kibana/tags)
- [Kibana 7.9.3](https://hub.docker.com/r/jamesgarside/kibana/tags)

## Usage
A basic `Docker-coompose.yml` file has been included with is repo to allow for basic testing. It will create one Elasticsearch instance and one Kibana instance

### Elastic Stack
I have an Elastic Stack for Arm Repo which can be [found here](https://github.com/jamesgarside/elastic-stack-arm).
This repo will deploy a full 3 node Elasticsearch Cluster with Crypt (TLS) along with a single Kibana Instance by running one script. 

## TODO
- [x] Create basic Dockerfile
- [ ] Package Kibana for Debian/Ubuntu Systems
- [ ] Package Kibana for CentOS/RHEL Systems


## Disclaimer
I've not fully tested these builds and as they are not 'supported' by Elastic I cannot gaurentee there won’t be issues, however in my testing I'm yet to come across any. 

## Credit
This blog post assisted with the development of this repo - https://toddysm.com/2020/06/09/learn-more-about-your-home-network-with-elastic-siem-part-1-setting-up-elastic-siem/
