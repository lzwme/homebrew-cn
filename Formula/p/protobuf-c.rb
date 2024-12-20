class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https:github.comprotobuf-cprotobuf-c"
  url "https:github.comprotobuf-cprotobuf-creleasesdownloadv1.5.0protobuf-c-1.5.0.tar.gz"
  sha256 "7b404c63361ed35b3667aec75cc37b54298d56dd2bcf369de3373212cc06fd98"
  license "BSD-2-Clause"
  revision 15

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "033a048cdddc037263304cf5102be982d9e741fc4d136ffe1426d6126d57ed7e"
    sha256 cellar: :any,                 arm64_sonoma:  "bba1e39e480fadac4356159e5c8e56eb8326ddb7a52b6c48278658bf1581ae24"
    sha256 cellar: :any,                 arm64_ventura: "fdaa89466f4a97f60f728e6fc1e9da0cddf7f09a36c671c51e51cd49d7a0878c"
    sha256 cellar: :any,                 sonoma:        "e39b6ef0b20522fa272e4be22ad59db2979c265389c32aebcd23058fa9d3a581"
    sha256 cellar: :any,                 ventura:       "8aae4d62b96d329a10c46875847cc7947955c88c6965a1d01496636381cae706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "175c871acb90fc795097e6b1383d06a44cc2a98bd49e9046f59307f4a620eeb9"
  end

  head do
    url "https:github.comprotobuf-cprotobuf-c.git", branch: "master"

    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
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
    (testpath"test.proto").write testdata
    system Formula["protobuf"].opt_bin"protoc", "test.proto", "--c_out=."

    testpath.glob("test.pb-c.*").map(&:unlink)
    system bin"protoc-c", "test.proto", "--c_out=."
  end
end