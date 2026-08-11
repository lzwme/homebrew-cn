class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://ghfast.top/https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "a08244115ed0535971ec894abf078da90ad2c0938700612f90dc550f218627ee"
  license "BSD-3-Clause"
  revision 5
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9545c554b14ff31a58dfa889b1d257a1ad766f95478d14615ec1bb8f375abdb5"
    sha256 cellar: :any, arm64_sequoia: "f13182fc94222ed70446b9171032f8daf9fe8d431c0c9b46241e0e2435f8759e"
    sha256 cellar: :any, arm64_sonoma:  "347286060284c012fedeb1e8471fd3b56606498da76ce481b6d94ddb773ba454"
    sha256 cellar: :any, sonoma:        "526d5b062f817640f167c07c761fe9ba51663870f71b63aa608b2ab8df71ecc3"
    sha256 cellar: :any, arm64_linux:   "06ced73a2d9474065dfe0f8fa5a4d007726c81a51882c297cc7b1847403cddb4"
    sha256 cellar: :any, x86_64_linux:  "e867e4d708b63a634a383fbe7e6546902240c0e64fabfa2acde91644864389da"
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
    system Formula["protobuf"].bin/"protoc", "--js_out=import_style=commonjs:.", "person.proto"
    assert_path_exists testpath/"person_pb.js"
    refute_predicate (testpath/"person_pb.js").size, :zero?
  end
end