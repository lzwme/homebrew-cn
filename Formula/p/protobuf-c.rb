class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://ghfast.top/https://github.com/protobuf-c/protobuf-c/releases/download/v1.5.2/protobuf-c-1.5.2.tar.gz"
  sha256 "e2c86271873a79c92b58fef7ebf8de1aa0df4738347a8bd5d4e65a80a16d0d24"
  license "BSD-2-Clause"
  revision 9

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bc26ff8747d29fbe554a6699737f2e2f65c2fa59e8fc53344223dd1dac5b8905"
    sha256 cellar: :any, arm64_sequoia: "00cf13774b89f7b3d9d69aeebf8e58d8ea6bcc31dc4d57ead80100c7465019b4"
    sha256 cellar: :any, arm64_sonoma:  "f54ead94b255e31558e5a793a8e6c465f259258cff1419f92292600ee1076ed5"
    sha256 cellar: :any, sonoma:        "3fa2fabe964f04153a32bc3f9f170d143480f7ce852f6c1e2eceb6c3a07e42ae"
    sha256               arm64_linux:   "bab8f1c35594761a30415f5bfc92b05c3e00d4e80c597e37ef58d79458e6370f"
    sha256               x86_64_linux:  "97b9b0a02027fa22e8f7e9c1ad4c279c7b77a3ff355ad0d9b2b5b1178ea417bc"
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