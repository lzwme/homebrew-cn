class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https:github.comprotocolbuffersprotobuf-javascript"
  url "https:github.comprotocolbuffersprotobuf-javascriptarchiverefstagsv3.21.4.tar.gz"
  sha256 "8cef92b4c803429af0c11c4090a76b6a931f82d21e0830760a17f9c6cb358150"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comprotocolbuffersprotobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "11d90ad5ca368c7b698e4fe28d13e7c71371fe85bedd34a9afdd06c7a28886b9"
    sha256 cellar: :any,                 arm64_sonoma:  "f8538372ecc9e3239beeb872fb7c56d41164d0aa7f538a1f7b6ddc80b61758bb"
    sha256 cellar: :any,                 arm64_ventura: "979f6a627242b10faa2faf29c7f43047d710e091187ae5302c0afdac7dfc6c4a"
    sha256 cellar: :any,                 sonoma:        "7b0a7b88e1bf43233f280e6e358ffa4cd84b133a50025bf00031d491e99fb906"
    sha256 cellar: :any,                 ventura:       "899e9f13317648d9c5f80fe4161e77c0d2b6f58f9d7096bca8f5ac13a83676c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06d9e3e5253a5c70c8fc5f5c3e075690033151da5a340b8c57fca85b2d8458ce"
  end

  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "protobuf"

  # We manually build rather than use Bazel as Bazel will build its own copy of Abseil
  # and Protobuf that get statically linked into binary. Check for any upstream changes at
  # https:github.comprotocolbuffersprotobuf-javascriptblobmaingeneratorBUILD.bazel
  def install
    protobuf_flags = Utils.safe_popen_read("pkg-config", "--cflags", "--libs", "protobuf").chomp.split.uniq
    system ENV.cxx, "-std=c++17", *Dir["generator*.cc"], "-o", "protoc-gen-js", "-I.", *protobuf_flags, "-lprotoc"
    bin.install "protoc-gen-js"
  end

  test do
    (testpath"person.proto").write <<~EOS
      syntax = "proto3";

      message Person {
        int64 id = 1;
        string name = 2;
      }
    EOS
    system Formula["protobuf"].bin"protoc", "--js_out=import_style=commonjs:.", "person.proto"
    assert_predicate testpath"person_pb.js", :exist?
    refute_predicate (testpath"person_pb.js").size, :zero?
  end
end