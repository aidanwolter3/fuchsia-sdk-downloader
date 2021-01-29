def _impl(repository_ctx):
  repository_ctx.file("BUILD", content="", executable=False)

  tar_base_url = "https://github.com/aidanwolter3/fuchsia-sdk-downloader/releases/download"
  tar_version = "f0850bdc"
  if repository_ctx.os.name == "linux":
    tar_file = "sdk-linux.tar.gz"
  elif repository_ctx.os.name == "mac os x":
    tar_file = "sdk-mac.tar.gz"
  else:
    fail("Unsupported platform: %s" % repository_ctx.os.name)

  tar_url = tar_base_url + "/" + tar_version + "/" + tar_file
  repository_ctx.download_and_extract(tar_url)


download_fuchsia_sdk = repository_rule(
    implementation = _impl,
)
