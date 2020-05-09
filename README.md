# Fuchsia Bazel SDK

**Version 2b9cd1b4**

Disclaimer: This is not an official Google project.

## How was this SDK generated?
1. Clone fuchsia following the steps on fuchsia.dev
2. Sync to the version
```bash
[~/fuchsia] $ jiri import -name=integration -overwrite=true \
    -revision=2b9cd1b40ea36181da9209e55ce31bcc558b9447 \
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
[~/fuchsia] $ mkdir ~/fuchsia_sdk
[~/fuchsia] $ ./scripts/sdk/bazel/generate.py \
    --archive out/default/sdk/archive/core.tar.gz \
    --output ~/fuchsia_sdk
```
