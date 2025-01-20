# From Serverful to Serverless Java with AWS Lambda

# Pre-Requisites

1. Install [AWS CDK](https://docs.aws.amazon.com/cdk/latest/guide/getting_started.html)
2. Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
3. Install [jq](https://stedolan.github.io/jq/download/)
4. Install [artillery](https://www.artillery.io/docs/guides/getting-started/installing-artillery)

# Architecture overview

Throughout this workshop we are going to work with an example application named **UnicornStore**.

The UnicornStore is a **Spring Boot Java Application** that provides CRUD-Operations for Unicorn-Records.
It stores them in a relational database (Postgres) and publishes and event afterwards in an eventbus (EventBridge).

![Unicorn Store](resources/unicorn-store-overview.png)

## Setup

The following script will build the infrastructure stack via AWS CDK.

```bash
./setup-infrastructure.sh
```

To deploy the different applications use:

```bash
./mvnw -f software/unicorn-store-spring/pom.xml spring-boot:run
```

To run a load test for the Spring-App use the following script:
```bash
./benchmark.sh spring 
```
## Security
The project uses [CDK-Nag](https://github.com/cdklabs/cdk-nag) to identify issues with the environment configuration. Since this is workshop environment we are
not using all the capabilities that you might need in production (E.g. Multi-AZ setup). Please refer to the CDK-Nag suppressions in the [CDK-App](infrastructure/cdk/src/main/java/com/unicorn/UnicornStoreApp.java) to identify certain choices
we have made for this setup.