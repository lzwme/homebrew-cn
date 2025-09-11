class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://ghfast.top/https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.2/protobuf-c-1.5.2.tar.gz"
  sha256 "e2c86271873a79c92b58fef7ebf8de1aa0df4738347a8bd5d4e65a80a16d0d24"
  license "BSD-2-Clause"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b4f0aca3a9b3164f8fab460e21dc4439a04d9fca0ca5a0a7245e7f4c6c41bae7"
    sha256 cellar: :any, arm64_sequoia: "303ee993c457be5869dd354400aaee47e5b33df56b6308786815af89a1a11e46"
    sha256 cellar: :any, arm64_sonoma:  "cd8d11fd77149fa0ad2dee76d173068217cdc66984b52eca6acc89d078c29cbf"
    sha256 cellar: :any, arm64_ventura: "80ce2c04ff312778c1907f57cb2355610077e200942f518422f5f37f995269b1"
    sha256 cellar: :any, sonoma:        "af8afbcb36efeccaa1c429a7bc3377311104aabf51bc835625f5ca885b27f3a1"
    sha256 cellar: :any, ventura:       "ed414a18245a717d734ea18af5f40f87ffd1172c7da3b920e228f9a9ff4664eb"
    sha256               arm64_linux:   "4a70845f2b14d68ebb31b94c3da49caca98a3a43ea538c006162ad5b27f92508"
    sha256               x86_64_linux:  "c874fc39572906280a570482c28f49b518389bff749068e8f58af2527d0e9d8e"
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