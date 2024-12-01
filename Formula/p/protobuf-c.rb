class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https:github.comprotobuf-cprotobuf-c"
  url "https:github.comprotobuf-cprotobuf-creleasesdownloadv1.5.0protobuf-c-1.5.0.tar.gz"
  sha256 "7b404c63361ed35b3667aec75cc37b54298d56dd2bcf369de3373212cc06fd98"
  license "BSD-2-Clause"
  revision 13

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "de456c5730dd9c4f1c85b0025c0d3a425651b5f8252b9d119a69e7ed54b6b303"
    sha256 cellar: :any,                 arm64_sonoma:  "20c9d206a73620e2bed2fed6eabe33f87863b29e241148921e0018b57d691114"
    sha256 cellar: :any,                 arm64_ventura: "0b3a54aaf1ebceb195e0c7300bade936e39f17c51c6249e8b91bfa99eb04bad5"
    sha256 cellar: :any,                 sonoma:        "27964d86508e9b13aa0f08209797e3688ef90d64322ace63381338be2aa1f337"
    sha256 cellar: :any,                 ventura:       "a4261bf4d6c6d722d0ada2b6e04e3dff294d8288bace2aa748cb87cf71e581fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f225ac0e0bcfa330a7f089b7c1b10e7387cdbe74f4be750d57731fd9562761b9"
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