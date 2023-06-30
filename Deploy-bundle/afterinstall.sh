#!/bin/bash

# Set the S3 bucket and path
S3_BUCKET="vprofile143"
ARTIFACT_PATH="target/vprofile-${version}.war"

# Set the Tomcat webapps directory
TOMCAT_WEBAPPS_DIR="/var/lib/tomcat9/webapps/"

# List objects in S3 bucket, sorted by last modified date
LATEST_OBJECT=$(aws s3api list-objects-v2 --bucket "$S3_BUCKET" --query 'sort_by(Contents, &LastModified)[*].[Key]' --output text --max-items 1)

# Copy the latest WAR file from S3 to webapps directory
aws s3 cp "s3://$S3_BUCKET/$LATEST_OBJECT" "$TOMCAT_WEBAPPS_DIR"
mv *.war vprofile-app.war

echo "artifact copied succesfully"
