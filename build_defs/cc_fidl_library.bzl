# Copyright 2018 The Fuchsia Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

load(":fidl_library.bzl", "FidlLibraryInfo")

# A cc_library backed by a FIDL library.
#
# Parameters
#
#   library
#     Label of the FIDL library.

CodegenInfo = provider(fields=["impl"])

def _codegen_impl(context):
    ir = context.attr.library[FidlLibraryInfo].ir
    name = context.attr.library[FidlLibraryInfo].name

    base_path = context.attr.name + ".cc"
    # This declaration is needed in order to get access to the full path.
    output = context.actions.declare_directory(base_path)
    stem = base_path + "/" + name.replace(".", "/") + "/cpp/fidl"
    header = context.actions.declare_file(stem + ".h")
    source = context.actions.declare_file(stem + ".cc")

    context.actions.run(
        executable = context.executable._fidlgen,
        arguments = [
            "--json",
            ir.path,
            "--output-base",
            header.dirname + "/fidl",
            "--include-base",
            output.path,
            "--generators",
            "cpp",
        ],
        inputs = [
            ir,
        ],
        outputs = [
            header,
            output,
            source,
        ],
        mnemonic = "FidlGenCc",
    )

    return [
        CodegenInfo(impl = source),
        DefaultInfo(files = depset([header]))
    ]

def _impl_wrapper_impl(context):
    file = context.attr.codegen[CodegenInfo].impl
    return [DefaultInfo(files = depset([file]))]

# Runs fidlgen to produce both the header file and the implementation file.
# Only exposes the header as a source, as the two files need to be consumed by
# the cc_library as two separate rules.
_codegen = rule(
    implementation = _codegen_impl,
    # Files must be generated in genfiles in order for the header to be included
    # anywhere.
    output_to_genfiles = True,
    attrs = {
        "library": attr.label(
            doc = "The FIDL library to generate code for",
            mandatory = True,
            allow_files = False,
            providers = [FidlLibraryInfo],
        ),
        "_fidlgen": attr.label(
            default = Label("//tools:fidlgen"),
            allow_single_file = True,
            executable = True,
            cfg = "host",
        ),
    }
)

# Simply declares the implementation file generated by the codegen target as an
# output.
# This allows the implementation file to be exposed as a source in its own rule.
_impl_wrapper = rule(
    implementation = _impl_wrapper_impl,
    output_to_genfiles = True,
    attrs = {
        "codegen": attr.label(
            doc = "The codegen rules generating the implementation file",
            mandatory = True,
            allow_files = False,
            providers = [CodegenInfo],
        ),
    }
)

def cc_fidl_library(name, library, deps=[], tags=[], visibility=None):
    gen_name = "%s_codegen" % name
    impl_name = "%s_impl" % name

    _codegen(
        name = gen_name,
        library = library,
    )

    _impl_wrapper(
        name = impl_name,
        codegen = ":%s" % gen_name,
    )

    native.cc_library(
        name = name,
        hdrs = [
            ":%s" % gen_name,
        ],
        srcs = [
            ":%s" % impl_name,
            # For the coding tables.
            library,
        ],
        # This is necessary in order to locate generated headers.
        strip_include_prefix = gen_name + ".cc",
        deps = deps + [
            Label("//pkg/fidl_cpp"),
        ],
        tags = tags,
        visibility = visibility,
    )
