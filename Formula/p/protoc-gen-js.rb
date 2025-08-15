class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://ghfast.top/https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v3.21.4.tar.gz"
  sha256 "8cef92b4c803429af0c11c4090a76b6a931f82d21e0830760a17f9c6cb358150"
  license "BSD-3-Clause"
  revision 11
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b658affe54eee085541fab58fb9d35cc6031bd7ca278db12d1a265fe276c4db8"
    sha256 cellar: :any,                 arm64_sonoma:  "46a32c6d040ec75abf2b73b4a91b32c0f1d8ab4631f38fdc0ad96121d8a99395"
    sha256 cellar: :any,                 arm64_ventura: "d2f5b55f2a50b3119ed1c30fb8b875158c8c9f0f692e62a35dc3b51c961c77f1"
    sha256 cellar: :any,                 sonoma:        "0b3fa26ac4b56f11d3f7ec386650ea4b78c567dcffb60b2106cddb91de5315ac"
    sha256 cellar: :any,                 ventura:       "758b80b0122a6e309414ecb5b266f8a926f5cba9e3fc57b5ce6a69a7b218f79e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a67b73fe726911472fbb1da0c152a41e20758d71a0258fb311b94ebd99b80a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fe521ef2b217ccbb76949f515836d918671d8753d627d590287ea2880518876"
  end

  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "protobuf@29"

  # We manually build rather than use Bazel as Bazel will build its own copy of Abseil
  # and Protobuf that get statically linked into binary. Check for any upstream changes at
  # https://github.com/protocolbuffers/protobuf-javascript/blob/main/generator/BUILD.bazel
  def install
    protobuf_flags = Utils.safe_popen_read("pkgconf", "--cflags", "--libs", "protobuf").chomp.split.uniq
    system ENV.cxx, "-std=c++17", *Dir["generator/*.cc"], "-o", "protoc-gen-js", "-I.", *protobuf_flags, "-lprotoc"
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
    system Formula["protobuf@29"].bin/"protoc", "--js_out=import_style=commonjs:.", "person.proto"
    assert_path_exists testpath/"person_pb.js"
    refute_predicate (testpath/"person_pb.js").size, :zero?
  end
end