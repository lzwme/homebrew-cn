class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https:github.comprotocolbuffersprotobuf-javascript"
  url "https:github.comprotocolbuffersprotobuf-javascriptarchiverefstagsv3.21.4.tar.gz"
  sha256 "8cef92b4c803429af0c11c4090a76b6a931f82d21e0830760a17f9c6cb358150"
  license "BSD-3-Clause"
  revision 4
  head "https:github.comprotocolbuffersprotobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "268ae26bbd746cc3dae8bc8a5b909a722884b3a9723265f0162093173933c5c3"
    sha256 cellar: :any,                 arm64_sonoma:  "37dc9be786dc713e39d9bbfb9932129579e586df69e41a6d5e9f3378fa2c6dac"
    sha256 cellar: :any,                 arm64_ventura: "f234f8fd9f083ead558648a7bf6c920b7f52dd975a91a3da3aa2bc11302cefaf"
    sha256 cellar: :any,                 sonoma:        "10e0db3d50b07b9b41662ff058d9b4ca617e3815a6b8728982043af920472bb6"
    sha256 cellar: :any,                 ventura:       "5d9925c663987f98b3cca35206537cb09731ad036591e4b6e1c8efe3eaacf8c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d95af729346133183c7fceb22db894bea374f2608488754e31d963cf3f15d0b"
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