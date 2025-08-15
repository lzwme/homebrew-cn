class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://ghfast.top/https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.2/protobuf-c-1.5.2.tar.gz"
  sha256 "e2c86271873a79c92b58fef7ebf8de1aa0df4738347a8bd5d4e65a80a16d0d24"
  license "BSD-2-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1c002276710e0332ffcfa7e46572941e11595520b7118511af0cfabf0cfd99d8"
    sha256 cellar: :any,                 arm64_sonoma:  "e13adbf799182db05b93d219af509a8fe3ff495daf3061645059be552935c515"
    sha256 cellar: :any,                 arm64_ventura: "8be34add0d50641ede48509f09d330f4f42b60c78e7aa2cbe0a4cf4fe26df906"
    sha256 cellar: :any,                 sonoma:        "4598ba5eb9c5c768469d394d3091e10fc02d85c7466dbf117ce32b22bee1c82e"
    sha256 cellar: :any,                 ventura:       "2963693b86d12750217b2aa0c2ba9044aeaa6d5346bdf050c172161bd83eed9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "775d1310599f6db9d072e86dc3d7fbc661f5f842089643073f2a01b8e1ea6035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ca237aaedafb7e101b66a7087dec147dc2950f4cc6fc950f499dfbaf72b4436"
  end

  head do
    url "https://github.com/protobuf-c/protobuf-c.git", branch: "master"

    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "protobuf"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    testdata = <<~PROTO
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    PROTO
    (testpath/"test.proto").write testdata
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--c_out=."

    testpath.glob("test.pb-c.*").map(&:unlink)
    system bin/"protoc-c", "test.proto", "--c_out=."
  end
end