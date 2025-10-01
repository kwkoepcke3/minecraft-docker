docker build --tag localhost/minecraft:$1 --build-arg JRE_VERSION=${1/jre/} .
