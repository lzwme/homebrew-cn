class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://ghfast.top/https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.2/protobuf-c-1.5.2.tar.gz"
  sha256 "e2c86271873a79c92b58fef7ebf8de1aa0df4738347a8bd5d4e65a80a16d0d24"
  license "BSD-2-Clause"
  revision 16
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "504d861b1dea900cf2aeefaf4b4b3c9dbec617b22007c4103c9e0b3934ffc540"
    sha256 cellar: :any, arm64_sequoia: "91693f3732661a7db008c00c790d22cd20b04abac23eb06d8aa57bfb78b15e02"
    sha256 cellar: :any, arm64_sonoma:  "88759a44c2dffdbd118b2858115374688b3caf9aa1e7f757b3e6f39818b71c17"
    sha256 cellar: :any, sonoma:        "b3ac0cd1313b0af6b001f174656ddbdc104566f523bceb391c5c825bdfb049c8"
    sha256               arm64_linux:   "1a82453bc93c4e00dcc05db077db0c13429de978cbc48c7d7f8c5ced91df2d6f"
    sha256               x86_64_linux:  "2d4f6224b4c2235a850d55695e80299ba72b5ba04e82a1593d0caa184513aa16"
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

  # Apply commit from open PR to support Protobuf 34
  patch do
    url "https://github.com/protobuf-c/protobuf-c/commit/d39f001b4578966600de0aaf7fc665eec6e057e5.patch?full_index=1"
    sha256 "10b5ea9c08f62be10ceb1df24a3211118a94cb0d09efcdf043ac3542368915fb"
    type :unofficial
    resolves "https://github.com/protobuf-c/protobuf-c/pull/797"
  end

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
    system formula_opt_bin("protobuf")/"protoc", "test.proto", "--c_out=."

    testpath.glob("test.pb-c.*").map(&:unlink)
    system bin/"protoc-c", "test.proto", "--c_out=."
  end
end