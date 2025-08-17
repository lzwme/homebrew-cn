class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://ghfast.top/https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.2/protobuf-c-1.5.2.tar.gz"
  sha256 "e2c86271873a79c92b58fef7ebf8de1aa0df4738347a8bd5d4e65a80a16d0d24"
  license "BSD-2-Clause"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_sequoia: "aa9ce6a2bbdd9fe5987e24751a03d3e4b27e01c38f275d8e772bc510dc10dfc4"
    sha256 cellar: :any, arm64_sonoma:  "6c2033d4e5c7694eb10b7e7147a02f576f4169585062d642f2acc944a234168a"
    sha256 cellar: :any, arm64_ventura: "4867d3082a4a4bcb2ecf3b02a373695732c1290615bfd9059d512ac63716e849"
    sha256 cellar: :any, sonoma:        "1bc6b1c1577ef27dbfd069cd641994e2add8a7c32d4296e9eae2f7238ef34736"
    sha256 cellar: :any, ventura:       "b88e35b77894ec32abb13ef1a8065b175374f883ec2018ab6770f43ee3a718b6"
    sha256               arm64_linux:   "647f833f018b378f1d1ac5d1866b4582965fa464becbe4084ff866ca3e390659"
    sha256               x86_64_linux:  "181cb56f2a8832855d3aefbed061cc9ba28305581a2e2c8109b0543a036bc798"
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