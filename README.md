# Fuchsia SDK Downloader

**Version f0850bdc**

Disclaimer: This is not an official Google project.

The Fuchsia SDK supports both mac and linux environments, but in two separate
SDKs. This Downloader will choose the right Fuchsia SDK based on the
environment, so that your project does not need to be hardcoded to either mac or
linux.

## Usage

**Workspace**
```
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

# Fetch the downloader
git_repository(
  name = "fuchsia_sdk_downloader",
  remote = "https://github.com/aidanwolter3/fuchsia-sdk-downloader",
)

# Download the correct Fuchsia SDK
load("@fuchsia_sdk_downloader//:download.bzl", "download_fuchsia_sdk")
download_fuchsia_sdk(
    name = "fuchsia_sdk",
)

# Prepare the Fuchsia SDK
load("@fuchsia_sdk//build_defs:fuchsia_setup.bzl", "fuchsia_setup")
fuchsia_setup(with_toolchain = True)
```

## How was the SDK generated?
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

## Local patches

The Fuchsia SDK does not work out-of-the-box, so I have manually applied some
patches to get it working. These are found in the `patches` directory.
