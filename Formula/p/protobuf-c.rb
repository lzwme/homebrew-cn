class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://ghproxy.com/https://github.com/protobuf-c/protobuf-c/releases/download/v1.4.1/protobuf-c-1.4.1.tar.gz"
  sha256 "4cc4facd508172f3e0a4d3a8736225d472418aee35b4ad053384b137b220339f"
  license "BSD-2-Clause"
  revision 9

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ca5c74cd7442d724251d73216979189f6bbcab19ec28ec46c9ad3754271f40bb"
    sha256 cellar: :any,                 arm64_ventura:  "082ac09ce977c3f7a732cf2d8b89d49d902c6e85e6208b6bad7f0cc05cbb60df"
    sha256 cellar: :any,                 arm64_monterey: "9185d97bc7c4ff65b392bf3bca15c8bff98381b677ae3c38caae64734634a06b"
    sha256 cellar: :any,                 sonoma:         "22886dbe1c6c99fdfc14a8eaa77f1a6cc1fd95c534c7475e660762b6231e7729"
    sha256 cellar: :any,                 ventura:        "e03e0f18ecdcefd41d6b57222b1ed6794d3f0243f051f3d7fde700f0b969d00c"
    sha256 cellar: :any,                 monterey:       "c4824400b94a6deb4c6113b7f29fd7c8dfa34987149f5e83a182dbe5facb7947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10dce16662fcb88e641faf6571097d6dfa90a0e4473f0285d436f13696897c77"
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