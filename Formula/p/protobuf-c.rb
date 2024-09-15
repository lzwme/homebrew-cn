class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https:github.comprotobuf-cprotobuf-c"
  url "https:github.comprotobuf-cprotobuf-creleasesdownloadv1.5.0protobuf-c-1.5.0.tar.gz"
  sha256 "7b404c63361ed35b3667aec75cc37b54298d56dd2bcf369de3373212cc06fd98"
  license "BSD-2-Clause"
  revision 10

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "646edf106738f44e084fd44b32ac6bc3074f091675b07ddfeacd47d7c09dc931"
    sha256 cellar: :any,                 arm64_sonoma:  "8af393eca725259e5d4463cff726fe9c6ba98df9ee185b2c4eca5d911bf1030c"
    sha256 cellar: :any,                 arm64_ventura: "804c9c5998fb563d30651f794823a979e62c170ac2853f9743f919941b60ebd1"
    sha256 cellar: :any,                 sonoma:        "4713016dbd31b6d24dd1177efa78911962cd9ca73ad91286a027077a0a555f5c"
    sha256 cellar: :any,                 ventura:       "80160e67d9215f70a1622da9600e849af9a04240ff1f34a3123aa0d3996f6b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bd10135a5e80ac1171ebf0891bbe0a81d69d425fd2722653ec4f91170788ed4"
  end

  head do
    url "https:github.comprotobuf-cprotobuf-c.git", branch: "master"

    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "protobuf"

  # Apply commits from open PR to support Protobuf 26.
  # PR ref: https:github.comprotobuf-cprotobuf-cpull711
  patch do
    url "https:github.comprotobuf-cprotobuf-ccommite3acc96ca2a00ef715fa2caa659f677cad8a9fa0.patch?full_index=1"
    sha256 "3b564a971023d127bb7b666e5669f792c94766836ccaed5acfae3e23b8152d43"
  end
  patch do
    url "https:github.comprotobuf-cprotobuf-ccommit1b4b205d87b1bc6f575db1fd1cbbb334a694abe8.patch?full_index=1"
    sha256 "6d02812445a229963add1b41c07bebddc3437fecb2a03844708512326fd70914"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system ".configure", *std_configure_args
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
    (testpath"test.proto").write testdata
    system Formula["protobuf"].opt_bin"protoc", "test.proto", "--c_out=."

    testpath.glob("test.pb-c.*").map(&:unlink)
    system bin"protoc-c", "test.proto", "--c_out=."
  end
end