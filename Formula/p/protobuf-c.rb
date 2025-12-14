class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://ghfast.top/https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.2/protobuf-c-1.5.2.tar.gz"
  sha256 "e2c86271873a79c92b58fef7ebf8de1aa0df4738347a8bd5d4e65a80a16d0d24"
  license "BSD-2-Clause"
  revision 8

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3b4d125f9113390e9a309723e2744d3105eaa8002c910547a1a6834651cd3232"
    sha256 cellar: :any, arm64_sequoia: "724915a627e377fd87c1b0f32a1ea6f1c28e0109f3933252074c29e5313bbba5"
    sha256 cellar: :any, arm64_sonoma:  "150744be0a14e2b581cc7bd93427daff1f066c6bfe64a69b97e0da1061ad7d0d"
    sha256 cellar: :any, sonoma:        "43a69b41d651caa5c6fb37c64dedca85dbf76ae506d830bbb5964fbabe29d0db"
    sha256               arm64_linux:   "95552399f01ec72d01ed1bb60b5aa829f6405abb6336ac68e8cd20baa680a890"
    sha256               x86_64_linux:  "dd8f855ff761e9757d0cf7e7f1be4446befde9d18c86eda683555d88b49d5cf6"
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