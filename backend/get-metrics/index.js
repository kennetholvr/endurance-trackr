import { DynamoDBClient, GetItemCommand } from "@aws-sdk/client-dynamodb";

const client = new DynamoDBClient({ region: process.env.AWS_REGION });

export const handler = async (event) => {
  const qs = event.queryStringParameters || {};
  const athlete_id = qs.athlete_id || "demo-athlete";
  const today = new Date().toISOString().slice(0, 10); // YYYY-MM-DD

  const resp = await client.send(new GetItemCommand({
    TableName: process.env.METRICS_TABLE,
    Key: { athlete_id: { S: athlete_id }, metric_date: { S: today } }
  }));

  return {
    statusCode: 200,
    headers: { "content-type": "application/json" },
    body: JSON.stringify({ date: today, athlete_id, metrics: resp.Item || {} })
  };
};
