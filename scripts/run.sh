#!/bin/bash

echo "{
\"url\": \"https://github.com/logtail/logtail-aws-lambda/releases/latest/download/logtail-aws-lambda.zip\",
\"checksum\": \"0588b968a890616f5fc877408f49381401496ca97b3a66c2e52e2096918b7119\",
\"file_name\": \"logtail-aws-lambda.zip\"
}" | python get_package.py
