class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://ghfast.top/https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v4.0.3.tar.gz"
  sha256 "43ea40481e7b5efdeccf4a0926226b0bd4f61386cdb819a55ce55f5828e32025"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e136d2018944327f9256fb65169623f428e755a8869ef5b5786abb5d09632e86"
    sha256 cellar: :any, arm64_tahoe:       "873d3c1f803c93e3cc897eb0a7a1f75764591dc9585f35ec2cfeb9ad68dc6bcb"
    sha256 cellar: :any, arm64_sequoia:     "b3a2c473db74ebb3f67995dba64cafa8bf27b10485c34a7d69de867a03f63b33"
    sha256 cellar: :any, arm64_linux:       "094e3473afa8bd212b78cac9e411e28beeac71ac2282553f60ee69c2ad540be9"
    sha256 cellar: :any, x86_64_linux:      "92dba2ce582c997b832cca6dfd1a112fe945b5ea650b4254ae7835b7fe677ecc"
  end

  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "protobuf"

  # We manually build rather than use Bazel as Bazel will build its own copy of Abseil
  # and Protobuf that get statically linked into binary. Check for any upstream changes at
  # https://github.com/protocolbuffers/protobuf-javascript/blob/main/generator/BUILD.bazel
  def install
    system ENV.cxx, "-std=c++17", "generator/generate-version-header.cc", "-o", "generate-version-header"
    system "./generate-version-header", "package.json", "generator/version.h"
    protobuf_flags = Utils.safe_popen_read("pkgconf", "--cflags", "--libs", "protobuf").chomp.split.uniq
    system ENV.cxx, "-std=c++17", "generator/js_generator.cc", "generator/protoc-gen-js.cc",
                    "generator/well_known_types_embed.cc", "-o", "protoc-gen-js", "-I.", *protobuf_flags, "-lprotoc"
    bin.install "protoc-gen-js"
  end

  test do
    (testpath/"person.proto").write <<~PROTO
      syntax = "proto3";

      message Person {
        int64 id = 1;
        string name = 2;
      }
    PROTO
    system formula_opt_bin("protobuf")/"protoc", "--js_out=import_style=commonjs:.", "person.proto"
    assert_path_exists testpath/"person_pb.js"
    refute_predicate (testpath/"person_pb.js").size, :zero?
  end
end