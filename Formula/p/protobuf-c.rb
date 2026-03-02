class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://ghfast.top/https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.2/protobuf-c-1.5.2.tar.gz"
  sha256 "e2c86271873a79c92b58fef7ebf8de1aa0df4738347a8bd5d4e65a80a16d0d24"
  license "BSD-2-Clause"
  revision 11

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "48996e72c65942fe6a8c5232430e2f47bc898095254b88f1746b85a8fbe058d0"
    sha256 cellar: :any, arm64_sequoia: "7d546d0e6f695b37020255b1ff7a0cc4470cd41891538c6c72a75dc109a267bb"
    sha256 cellar: :any, arm64_sonoma:  "039b508dab95a4c4d352351187a951e84b3a979d7732d4fa1a4a65aa833880da"
    sha256 cellar: :any, sonoma:        "5b88cb85c69afc9aae7a15f0b6690db720d6332f15e5e577f75f5074e3e469b6"
    sha256               arm64_linux:   "8ab0878b33fb294aecc3967836cf21eb0b5276cb55111567bdb3532495004271"
    sha256               x86_64_linux:  "26f89c7d7c5c7e0e46cc81f8da049a86cd69d02e35de2deacb02917a4ba5421a"
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
  depends_on "protobuf@33" # https://github.com/protobuf-c/protobuf-c/issues/795

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
    system Formula["protobuf@33"].opt_bin/"protoc", "test.proto", "--c_out=."

    testpath.glob("test.pb-c.*").map(&:unlink)
    system bin/"protoc-c", "test.proto", "--c_out=."
  end
end