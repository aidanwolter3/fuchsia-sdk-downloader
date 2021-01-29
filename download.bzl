DOWNLOAD_SDK_SH="""
#!/bin/bash
sdk_url="$1"
branch="$2"
git init
git remote add origin "${sdk_url}"
git fetch origin "${branch}"
git checkout "${branch}"
"""


# LOCAL_SDK_SH="""
# #!/bin/bash
# tar_path="$1"
# tar -xf "${tar_path}"
# """

def _impl(repository_ctx):
  repository_ctx.file("BUILD", content="", executable=False)

  if repository_ctx.os.name == "linux":
    tar_url = "linux"
  elif repository_ctx.os.name == "mac os x":
    tar_url = "mac"
  else:
    fail("Unsupported platform: %s" % repository_ctx.os.name)

  repository_ctx.file("download_sdk.sh", content=DOWNLOAD_SDK_SH)
  repository_ctx.execute(["./download_sdk.sh", tar_url])

  # repository_ctx.file("local_sdk.sh", content=LOCAL_SDK_SH)
  # repository_ctx.execute(["./local_sdk.sh", tar_url])


download_fuchsia_sdk = repository_rule(
    implementation = _impl,
)
