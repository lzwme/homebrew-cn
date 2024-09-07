class ProtocGenJs < Formula
  desc "Protocol buffers JavaScript generator plugin"
  homepage "https:github.comprotocolbuffersprotobuf-javascript"
  url "https:github.comprotocolbuffersprotobuf-javascriptarchiverefstagsv3.21.4.tar.gz"
  sha256 "8cef92b4c803429af0c11c4090a76b6a931f82d21e0830760a17f9c6cb358150"
  license "BSD-3-Clause"
  head "https:github.comprotocolbuffersprotobuf-javascript.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e88d8c9da16d90a087cc06fd673be15d0e0fbb994db142aace7f7d60b47ab98f"
    sha256 cellar: :any,                 arm64_ventura:  "e9eb75b369a9299861a58c79ab2be463859c715492d09ae74d762e7bd255c8c1"
    sha256 cellar: :any,                 arm64_monterey: "fd3b137f6fb2a3ef81352949a399c8a3674f04331903f054732fa13740e3a2d3"
    sha256 cellar: :any,                 sonoma:         "8d3e2bc657967f30ea03409f6942fc9f6e1c4297a36266dc82872bc9b20d1299"
    sha256 cellar: :any,                 ventura:        "76a813a7c9228db8c43d7860ffe1ba0c421aaf0c5e5932a65579e78a57e61c14"
    sha256 cellar: :any,                 monterey:       "c381ff81bee4bc885a5f94d3369cb2ae94ed2edba0309ffbd34f0725cf2c94e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cf5bc2842890a2fa165808f0ccd944f952f42a1d18573def7c21d7516dadf71"
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