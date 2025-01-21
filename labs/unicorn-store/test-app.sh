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

  status=$(curl --location --request GET $(cat infrastructure/cdk/target/output.json | jq -r '.UnicornStoreSpringApp.ApiEndpointSpring')'/unicorns' \
| jq -r '.name')
if [ $status != null ]
then
  echo $status
  curl --location --request GET $(cat infrastructure/cdk/target/output.json | jq -r '.UnicornStoreSpringApp.ApiEndpointSpring')'/unicorns' \
  | jq
  echo "Test Passed"
  exit 0
else
  echo "Test Failed"
  exit 1
fi

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

  status=$(curl --location --request GET 'http://localhost:8080/unicorns/' \
| jq -r '.name')

if [ $status == null ]
then
  curl --location --request GET 'http://localhost:8080/unicorns' \
  | jq
    echo "Test Passed"
  exit 0
else
  echo "Test Failed"
  exit 1
fi

fi


