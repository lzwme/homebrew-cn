class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https:github.comprotobuf-cprotobuf-c"
  url "https:github.comprotobuf-cprotobuf-creleasesdownloadv1.5.0protobuf-c-1.5.0.tar.gz"
  sha256 "7b404c63361ed35b3667aec75cc37b54298d56dd2bcf369de3373212cc06fd98"
  license "BSD-2-Clause"
  revision 9

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "4a9f3feb96ee3c7670b22d2a4f51813ccf3cf8f920ba6dba1633d3b009b35a37"
    sha256 cellar: :any,                 arm64_sonoma:   "49636dfd5df7def8576af5928bf8645797afe189b08fc8cbe354e13d3f118f6f"
    sha256 cellar: :any,                 arm64_ventura:  "990e2c5b4f749231c980ba344de3630bfed02f8ec1a882fc0b9da5e1214f36a2"
    sha256 cellar: :any,                 arm64_monterey: "90a1f307a9985cdac770980f9c10ba02005ca83d79c8587f3ae704b10f758968"
    sha256 cellar: :any,                 sonoma:         "ed5623554239e64dfe3fb7ef95588550ad677c17da437729e0a90f76ff8153eb"
    sha256 cellar: :any,                 ventura:        "0176121e12c36bea25aed0d2f8fd2a353f587b0c05806008d30984f20db81767"
    sha256 cellar: :any,                 monterey:       "b5f714ea31cf2f52e637b8c4566469e00a76f1f2d432abfa6250f0afaa8f0d1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b53fab733fe9ce4e1620fb0d88f4e83964689b42fdaee7539551615090c4daaf"
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