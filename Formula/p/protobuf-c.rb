class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://ghfast.top/https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.2/protobuf-c-1.5.2.tar.gz"
  sha256 "e2c86271873a79c92b58fef7ebf8de1aa0df4738347a8bd5d4e65a80a16d0d24"
  license "BSD-2-Clause"
  revision 6

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a1a04ba412326f28d61d83f7f4a50f580447fe1402c8ba6c46ef4396f2627463"
    sha256 cellar: :any, arm64_sequoia: "ffc3d776736ddcb16b9c050d9cfd43d73cb1493c64aa4505dab7f7d06129580b"
    sha256 cellar: :any, arm64_sonoma:  "9a1bb30a18c4fcee0807b707df899416c65758324990f31b7b3b1d3935a34c36"
    sha256 cellar: :any, sonoma:        "fd1d27bc2a7c9c7b7406119407bf973791762a15d70956d116d01d3c85d7745c"
    sha256               arm64_linux:   "1e541a71b82316d1f6f0bdf3f705bbda55a580a745431dd1a74b64770db161c4"
    sha256               x86_64_linux:  "195451b729abe5e190ffa718d9d27e685cef16674070a6657e309987808bba3e"
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