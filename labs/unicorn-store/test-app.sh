#bin/sh

app=$1

if [ $app == "spring" ]
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





