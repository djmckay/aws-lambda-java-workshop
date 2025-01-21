#bin/sh

app=$1
build=$2

if [ $app == "spring-local" ]
then
  if [[ $build == "--build" ]]
  then
    # Build the database setup function
      ./mvnw clean package -f infrastructure/db-setup/pom.xml

      # Build the unicorn application
      ./mvnw clean package -P local -f software/unicorn-store-spring/pom.xml
  fi

  # Deploy the infrastructure
  cd infrastructure/cdk

  cdk bootstrap
  cdk deploy UnicornStoreInfrastructure --require-approval never --outputs-file target/output.json

  # Execute the DB Setup function to create the table
  lambda_result=$(aws lambda invoke --function-name $(cat target/output.json | jq -r '.UnicornStoreInfrastructure.DbSetupArn') /dev/stdout 2>&1)
  # Extract the status code from the response payload
  lambda_status_code=$(echo "$lambda_result" | jq 'first(.. | objects | select(has("statusCode"))) | .statusCode')

  if [ "$lambda_status_code" == "200" ]; then
      echo "DB Setup Lambda function executed successfully"
      cd ../../
      export SPRING_DATASOURCE_PASSWORD=$(aws secretsmanager get-secret-value --secret-id unicornstore-db-secret | jq --raw-output '.SecretString' | jq -r .password)
      export SPRING_DATASOURCE_URL=jdbc:postgresql://$(aws rds describe-db-instances --db-instance-identifier unicornInstance --query "DBInstances[*].Endpoint.Address" | jq -r ".[]"):5432/unicorns
      echo $SPRING_DATASOURCE_URL
      export AWS_REGION=$(aws configure get region)

      ./mvnw -P local -f software/unicorn-store-spring/pom.xml spring-boot:run
  else
      echo "DB Setup Lambda function execution failed"
      exit 1
  fi
fi

if [ $app == "spring-aws" ]
then
  if [[ $build == "--build" ]]
  then
    ./mvnw clean package -P aws -f software/unicorn-store-spring/pom.xml
  fi
  cd infrastructure/cdk
  cdk deploy UnicornStoreSpringApp --outputs-file target/output.json --require-approval never

  # Execute the DB Setup function to create the table
    lambda_result=$(aws lambda invoke --function-name $(cat target/output.json | jq -r '.UnicornStoreInfrastructure.DbSetupArn') /dev/stdout 2>&1)
    # Extract the status code from the response payload
    lambda_status_code=$(echo "$lambda_result" | jq 'first(.. | objects | select(has("statusCode"))) | .statusCode')

    if [ "$lambda_status_code" == "200" ]; then
        echo "DB Setup Lambda function executed successfully"
    else
        echo "DB Setup Lambda function execution failed"
        exit 1
    fi

  exit 0
fi


