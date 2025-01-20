#bin/sh

app=$1

if [ $app == "spring-aws" ]
then
  curl --location --request POST $(cat infrastructure/cdk/target/output.json | jq -r '.UnicornStoreSpringApp.ApiEndpointSpring')'/unicorns' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "name": "Something",
    "age": "Older",
    "type": "Animal",
    "size": "Very big"
}' | jq

  exit 0
fi

if [ $app == "spring-local" ]
then
  curl --location --request POST 'http://localhost:8080/unicorns' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "name": "Something",
    "age": "Older",
    "type": "Animal",
    "size": "Very big"
}' | jq

  exit 0
fi


