"""An AWS Python Pulumi program"""

from pulumi_aws import s3

import pulumi

# Create an AWS resource (S3 Bucket)
bucket = s3.Bucket(
    "my-bucket",
    # index.htmlをwebsiteのindexとして設定
    website=s3.BucketWebsiteArgs(
        index_document="index.html",
    ),
)

# S3バケットの所有権の設定
ownership_controls = s3.BucketOwnershipControls(
    "ownership-controls",
    bucket=bucket.id,
    rule=s3.BucketOwnershipControlsRuleArgs(
        object_ownership="ObjectWriter",
    ),
)

# S3バケットの公開アクセスを許可する
public_access_block = s3.BucketPublicAccessBlock(
    "public-access-block",
    bucket=bucket.id,
    block_public_acls=False,
)

# Create a Pulumi resource (AWS S3 Bucket Object)
bucket_object = s3.BucketObject(
    "index.html",
    bucket=bucket.id,
    source=pulumi.FileAsset("index.html"),
    content_type="text/html",
    acl="public-read",
    opts=pulumi.ResourceOptions(depends_on=[public_access_block]),
)

# Export the name of the bucket
pulumi.export(
    "bucket_endpoint",
    pulumi.Output.concat("http://", bucket.website_endpoint),
)
