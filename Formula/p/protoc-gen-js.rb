class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https://github.com/protocolbuffers/protobuf-javascript"
  url "https://ghfast.top/https://github.com/protocolbuffers/protobuf-javascript/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "a08244115ed0535971ec894abf078da90ad2c0938700612f90dc550f218627ee"
  license "BSD-3-Clause"
  head "https://github.com/protocolbuffers/protobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "16e55d7c88f0fb3e16aae2220f54a00fb93cf32350afe1631884452e7e02584f"
    sha256 cellar: :any,                 arm64_sequoia: "1a736dd76989d61a4f4148088ca8e7b4178240d10fcf1b558f03e78e6f97930a"
    sha256 cellar: :any,                 arm64_sonoma:  "692ee1c3eb53ab457bc70cf4ebe56360c6d1052e3f66b1d60c4c28eafb7a3aa2"
    sha256 cellar: :any,                 sonoma:        "89f23b91a5cff99b988237ef831f7a4237ac947d61e42fe5a4662bad2c5f933a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc8bfc5662384fe1c6b0eacd40c10523447459cfd652996fdfdacc89de6f748f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "600621ff129fd4511f9d6bb7d83164ac834c57daa61c919e6526285c0e7fe943"
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