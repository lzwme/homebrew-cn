class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https:github.comprotocolbuffersprotobuf-javascript"
  url "https:github.comprotocolbuffersprotobuf-javascriptarchiverefstagsv3.21.4.tar.gz"
  sha256 "8cef92b4c803429af0c11c4090a76b6a931f82d21e0830760a17f9c6cb358150"
  license "BSD-3-Clause"
  revision 6
  head "https:github.comprotocolbuffersprotobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e1945e2df2a6985797fb0923a7d97f9f57eaf45d8b7e46e8731a31f9f3163ee8"
    sha256 cellar: :any,                 arm64_sonoma:  "b8b79ddb3a4aad5302faad3467d2b83f6909939fd1d2ac3be24fc8d79f45b73b"
    sha256 cellar: :any,                 arm64_ventura: "51be741555a7cd78a9df1db9306f0206a260c3efb35fd526080e0a3b4414a513"
    sha256 cellar: :any,                 sonoma:        "e690a1aff45e2f591cd15030e6e5c537b66b9334e4540a621e57fec60833aefc"
    sha256 cellar: :any,                 ventura:       "43ee45c035731db9384dcdd90f0b8c230a955769c1178769bf60005b635ebe0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c2685e8616158bff305062d1f912ca348f51c34115eb1e322b334c900893f60"
  end

  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "protobuf"

  # We manually build rather than use Bazel as Bazel will build its own copy of Abseil
  # and Protobuf that get statically linked into binary. Check for any upstream changes at
  # https:github.comprotocolbuffersprotobuf-javascriptblobmaingeneratorBUILD.bazel
  def install
    protobuf_flags = Utils.safe_popen_read("pkgconf", "--cflags", "--libs", "protobuf").chomp.split.uniq
    system ENV.cxx, "-std=c++17", *Dir["generator*.cc"], "-o", "protoc-gen-js", "-I.", *protobuf_flags, "-lprotoc"
    bin.install "protoc-gen-js"
  end

  test do
    (testpath"person.proto").write <<~PROTO
      syntax = "proto3";

      message Person {
        int64 id = 1;
        string name = 2;
      }
    PROTO
    system Formula["protobuf"].bin"protoc", "--js_out=import_style=commonjs:.", "person.proto"
    assert_path_exists testpath"person_pb.js"
    refute_predicate (testpath"person_pb.js").size, :zero?
  end
end