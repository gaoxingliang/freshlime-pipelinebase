a base image for pipeline contains:
- docker
- java
- npm
Exposed a volume named `/code`
# how to build
docker build -t edwardg/freshlime-pipelinebase:1.0 . 

# how to run an exmaple
```
docker run -d -it -v /Users/ed_freshlime/projects/fl/fl-connection:/code edwardg/freshlime-pipelinebase:1.0 sleep infinity
```