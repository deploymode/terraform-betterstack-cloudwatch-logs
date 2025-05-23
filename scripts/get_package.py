#!/usr/bin/env python3
import hashlib
import json
import os
import sys
import urllib.request


def download_file(url, dest):
    try:
        urllib.request.urlretrieve(url, dest)
    except Exception as e:
        print(json.dumps({"error": str(e)}))
        sys.exit(1)


def compute_sha256(file_path):
    sha256 = hashlib.sha256()
    try:
        with open(file_path, "rb") as f:
            while chunk := f.read(8192):
                sha256.update(chunk)
        return sha256.hexdigest()
    except Exception as e:
        print(json.dumps({"error": str(e)}))
        sys.exit(1)


if __name__ == "__main__":
    # Read input parameters from Terraform
    input_data = json.load(sys.stdin)
    url = input_data.get("url")
    expected_checksum = input_data.get("checksum")
    file_name = input_data.get("file_name")
    dest = os.path.join(os.getcwd(), file_name)

    download_file(url, dest)
    actual_checksum = compute_sha256(dest)

    if actual_checksum != expected_checksum:
        print(
            json.dumps(
                {
                    "error": f"Checksum mismatch! Expected {expected_checksum}, got {actual_checksum}"
                }
            )
        )
        sys.exit(1)

    print(json.dumps({"checksum": actual_checksum, "file": dest}))
