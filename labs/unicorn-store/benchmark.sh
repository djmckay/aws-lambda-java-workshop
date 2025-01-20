#bin/sh

app=$1

if [ $app == "spring-aws" ]
then
  artillery run -t $(cat infrastructure/cdk/target/output.json | jq -r '.UnicornStoreSpringApp.ApiEndpointSpring') -v '{ "url": "/unicorns" }' infrastructure/loadtest.yaml
  exit 0
fi

if [ $app == "spring-local" ]
then
  artillery run -t 'http://localhost:8080' -v '{ "url": "/unicorns" }' infrastructure/loadtest.yaml
  exit 0
fi




