#bin/sh

app=$1
build=$2

if [ $app == "spring-aws" ]
then
  if [[ $build == "--build" ]]
  then
    ./mvnw clean package -f software/unicorn-store-spring/pom.xml
  fi
  cd infrastructure/cdk
  cdk deploy UnicornStoreSpringApp --outputs-file target/output.json --require-approval never
  exit 0
fi

if [ $app == "audit-service" ]
then
  if [[ $build == "--build" ]]
  then
    ./mvnw clean package -f software/alternatives/unicorn-audit-service/pom.xml
  fi
  cd infrastructure/cdk
  cdk deploy UnicornAuditServiceApp --outputs-file target/output-audit-service.json --require-approval never
  exit 0
fi

