class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://ghproxy.com/https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.0/protobuf-c-1.5.0.tar.gz"
  sha256 "7b404c63361ed35b3667aec75cc37b54298d56dd2bcf369de3373212cc06fd98"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fafeb03e9ac4ab7536eafefebd63f7db812b960a2fb16d83a937aa80a70b4158"
    sha256 cellar: :any,                 arm64_ventura:  "aeec7fbd83468ac568828aaad7862f9f03965a465f703304253f73052f306150"
    sha256 cellar: :any,                 arm64_monterey: "18fccf7cbc69da71f10768a8ea0464b6be1ec3dc148b23e9eddbcf68086785bf"
    sha256 cellar: :any,                 sonoma:         "6a56823964abb27099fa90402d7e0d9e9e771d48cddd787c1d0ceeb8b1aff897"
    sha256 cellar: :any,                 ventura:        "23f15144f03228f640d3f75eafe3a3bd047558d31f1e483380902f891f00f6e8"
    sha256 cellar: :any,                 monterey:       "9a8744982010994dedce83c77cbca63ef431a060c10191e7fcf04773f976ba71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b33c881b3ba12e613208cd359310bb44f72aacd66e9da40243944922381f744"
  end

  head do
    url "https://github.com/protobuf-c/protobuf-c.git", branch: "master"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    testdata = <<~EOS
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS
    (testpath/"test.proto").write testdata
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--c_out=."
  end
end