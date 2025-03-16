class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https:github.comprotocolbuffersprotobuf-javascript"
  url "https:github.comprotocolbuffersprotobuf-javascriptarchiverefstagsv3.21.4.tar.gz"
  sha256 "8cef92b4c803429af0c11c4090a76b6a931f82d21e0830760a17f9c6cb358150"
  license "BSD-3-Clause"
  revision 8
  head "https:github.comprotocolbuffersprotobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cbb18a5e1f74549805df90aeb3c51863148b745d727155e8fbe66db7e7f3c2f8"
    sha256 cellar: :any,                 arm64_sonoma:  "4a844f516417b1b7f26d0afa7201787c29774d25145b83b7db55dd20160458b8"
    sha256 cellar: :any,                 arm64_ventura: "beda6ac3c389b97f9576a937f9f05a7d5eb080266616cbc3f5c128dc640087d0"
    sha256 cellar: :any,                 sonoma:        "b27424da44d8473270ad385e5d02b652e812f6fffbc6463bc7db9298532cfd13"
    sha256 cellar: :any,                 ventura:       "ef8957fa3237a984dd1cb5abca15f38578e2705041f54ffa98853e99b7775651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b73db501545dd71f9d63bdac58dd15dbab247ecabcb1f20798323af9c5280d90"
  end

  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "protobuf@29"

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
    system Formula["protobuf@29"].bin"protoc", "--js_out=import_style=commonjs:.", "person.proto"
    assert_path_exists testpath"person_pb.js"
    refute_predicate (testpath"person_pb.js").size, :zero?
  end
end