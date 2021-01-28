# Fuchsia Bazel SDK

**Version f0850bdc**

Disclaimer: This is not an official Google project.

## How to use this SDK

Note: This is not the cleanest at the moment. It would be nice to upstream the
local patches, create releases with archives for the SDKs, and include the logic
for downloading the appropriate SDK archive into this repository.

The `linux` and `mac` branches hold the actual SDKs for each corresponding
platform. Simply clone the repository, then checkout the proper branch.

## How was this SDK generated?
1. Clone fuchsia following the steps on fuchsia.dev
2. Sync to the version
```bash
[~/fuchsia] $ jiri import -name=integration -overwrite=true \
    -revision=f0850bdc5e85780dbd3b0eefe962afc544b05137 \
    flower https://fuchsia.googlesource.com/integration
[~/fuchsia] $ rm -rf integration
[~/fuchsia] $ jiri update -gc
```
3. Build the core SDK
```bash
[~/fuchsia] $ fx set core.x64 --with //sdk:core --args="build_sdk_archives=true"
[~/fuchsia] $ fx build sdk:core
```
4. Generate the Bazel frontend
```bash
[~/fuchsia] $ mkdir ~/fuchsia-bazel-sdk
[~/fuchsia] $ ./scripts/sdk/bazel/generate.py \
    --archive out/default/sdk/archive/core.tar.gz \
    --output ~/fuchsia-bazel-sdk
```
