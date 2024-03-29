# NOTICE
Elastic now support multi-architectures within their official Dockerfiles for Kibana. [These files can be found here](https://github.com/elastic/dockerfiles)
At current Elastic haven’t added ARM to their Kibana image build pipeline despite the Dockerfiles supporting it. Until they add it to the official pipeline I will build the Kibana images for ARM and upload them to my Dockerhub registry. 

# Kibana builds for ARM
This repo will contain builds of Kibana for ARM. 

If the build you are looking for isn’t here please contact me.
Feel free to branch and update yourselves. 

## Docker Description
This a modified version of the Official Dockerfile found [here](https://github.com/elastic/dockerfiles/blob/7.11.2/kibana/Dockerfile)

Since 7.11.0 the Node re2 module needs recompiling as the shipped version is compiled for x86. This is handled a the container time of creation.

## Docker Images
Pre-built docker images can be found on my Dockerhub [here](https://hub.docker.com/r/jamesgarside/kibana/).

- [Kibana 7.12.0](https://hub.docker.com/r/jamesgarside/kibana/tags)
- [Kibana 7.11.2](https://hub.docker.com/r/jamesgarside/kibana/tags)
- [Kibana 7.11.1](https://hub.docker.com/r/jamesgarside/kibana/tags)
- [Kibana 7.11.0](https://hub.docker.com/r/jamesgarside/kibana/tags)
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
