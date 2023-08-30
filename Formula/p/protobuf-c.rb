class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://ghproxy.com/https://github.com/protobuf-c/protobuf-c/releases/download/v1.4.1/protobuf-c-1.4.1.tar.gz"
  sha256 "4cc4facd508172f3e0a4d3a8736225d472418aee35b4ad053384b137b220339f"
  license "BSD-2-Clause"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4689cc1153047157f1f2b37bcf47eff679e4e6783455936253ab6ccbc792fc1d"
    sha256 cellar: :any,                 arm64_monterey: "b204637d0910b4eb60855367b141468ad46f1c18bfefea0d3dca17b53c27027b"
    sha256 cellar: :any,                 arm64_big_sur:  "8a85d4b10a366b42c56fe0470174a13ab0130652f8b3034f93c79ae944ef81be"
    sha256 cellar: :any,                 ventura:        "bd587d3c4dc0be717862bf99186318c5295fbf9eb4a9ae307d4f368f667613c1"
    sha256 cellar: :any,                 monterey:       "f502bbad1457ee1d136a14fb84d5ba788bfba0f44734423377b892ff424789c2"
    sha256 cellar: :any,                 big_sur:        "9969b0ad88283aa2af06b438b261feec9c6abb5a086c596e4a0d43921a1d1ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "525c7b8ba27d24af6842b1f1aab9205ac9a97513ae5387d0e1068f9fa6a2958d"
  end

  head do
    url "https://github.com/protobuf-c/protobuf-c.git", branch: "master"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # TODO: `autoconf`, `automake`, and `libtool` are needed for the patches.
  #       Remove when they are no longer needed.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf"

  # The next three patches are for compatibility with the newest protobuf.
  # https://github.com/protobuf-c/protobuf-c/pull/556
  # TODO: Uncomment `if build.head?` in `#install` when these are no longer needed.
  patch do
    url "https://github.com/protobuf-c/protobuf-c/commit/66a0b0d205224f63f19dd8f96abf9dcdc2112331.patch?full_index=1"
    sha256 "a3561ad37f33048c59a1ceece246a515b62cef91126e4041056d10ea26a19230"
  end

  patch do
    url "https://github.com/protobuf-c/protobuf-c/commit/7706c95d4835e75f182ab56d9dad5c8cd8517e0a.patch?full_index=1"
    sha256 "86364b4da6e077bd9f89a82d6e2ac965776ee1a544e43d1964c2e800424cdb6e"
  end

  patch do
    url "https://github.com/protobuf-c/protobuf-c/commit/66574f3fd85a205eb7c90b790477d5415364209e.patch?full_index=1"
    sha256 "2d1d6edbd615dff4f0a9c4a974d325effefc44466e1855f8c0b88e5977962a9d"
  end

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"

    # TODO: Uncomment `if build.head?` when the patches are no longer needed.
    system "autoreconf", "--force", "--install", "--verbose" # if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
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