#!/bin/sh

DETAILS=$(aws dynamodb describe-table --profile "$AWS_PROFILE" --table-name "$SOCCER_TABLE" --endpoint-url "http://localhost:$DYNAMODB_PORT" --region "$AWS_REGION" 2>/dev/null)

if [ "$?" -eq 0 ]; then
  echo "Deleting DynamoDB table $SOCCER_TABLE before recreating it..."
  aws dynamodb delete-table \
      --endpoint-url "http://localhost:$DYNAMODB_PORT" \
      --table-name "$SOCCER_TABLE" \
      --profile "$AWS_PROFILE" \
      --region "$AWS_REGION"
fi

echo "Creating DynamoDB table $SOCCER_TABLE..."
aws dynamodb create-table \
    --profile "$AWS_PROFILE" \
    --endpoint-url "http://localhost:$DYNAMODB_PORT" \
    --table-name "$SOCCER_TABLE" \
    --attribute-definitions \
        AttributeName=Id,AttributeType=S \
        AttributeName=Metadata,AttributeType=S \
        AttributeName=GameDay,AttributeType=S \
        AttributeName=PlayerName,AttributeType=S \
    --key-schema \
        AttributeName=Id,KeyType=HASH \
        AttributeName=Metadata,KeyType=RANGE \
    --provisioned-throughput \
        ReadCapacityUnits=10,WriteCapacityUnits=5 \
    --global-secondary-indexes \
    "[
            {
                \"IndexName\": \"MetadataIndex\",
                \"KeySchema\": [
                    {
                        \"AttributeName\": \"Metadata\",
                        \"KeyType\": \"HASH\"
                    }
                ],
                \"Projection\": { \"ProjectionType\": \"ALL\" },
                \"ProvisionedThroughput\": {
                    \"ReadCapacityUnits\": 1,
                    \"WriteCapacityUnits\": 1
                }
            },
            {
                \"IndexName\": \"MetadataGameIndex\",
                \"KeySchema\": [
                    {
                        \"AttributeName\": \"Metadata\",
                        \"KeyType\": \"HASH\"
                    },
                    {
                        \"AttributeName\": \"GameDay\",
                        \"KeyType\": \"RANGE\"
                    }
                ],
                \"Projection\": { \"ProjectionType\": \"ALL\" },
                \"ProvisionedThroughput\": {
                    \"ReadCapacityUnits\": 1,
                    \"WriteCapacityUnits\": 1
                }
            },
            {
                \"IndexName\": \"MetadataPlayereIndex\",
                \"KeySchema\": [
                    {
                        \"AttributeName\": \"Metadata\",
                        \"KeyType\": \"HASH\"
                    },
                    {
                        \"AttributeName\": \"PlayerName\",
                        \"KeyType\": \"RANGE\"
                    }
                ],
                \"Projection\": { \"ProjectionType\": \"ALL\" },
                \"ProvisionedThroughput\": {
                    \"ReadCapacityUnits\": 1,
                    \"WriteCapacityUnits\": 1
                }
            }
        ]" \
  --region "${AWS_REGION}"

echo "Completed creating DynamoDB table $SOCCER_TABLE."
