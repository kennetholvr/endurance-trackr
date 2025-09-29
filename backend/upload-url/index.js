import { S3Client, PutObjectCommand } from "@aws-sdk/client-s3";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";

const client = new S3Client({ region: process.env.AWS_REGION });

export const handler = async (event) => {
  const body = JSON.parse(event.body || "{}");
  const filename = body.filename || `upload-${Date.now()}.gpx`;
  const key = `uploads/${filename}`;

  const cmd = new PutObjectCommand({
    Bucket: process.env.RAW_BUCKET,
    Key: key,
    // ContentType: "application/gpx+xml"
  });

  const url = await getSignedUrl(client, cmd, { expiresIn: 900 });
  return {
    statusCode: 200,
    headers: { "content-type": "application/json" },
    body: JSON.stringify({ bucket: process.env.RAW_BUCKET, key, url, expires_in: 900 })
  };
};
