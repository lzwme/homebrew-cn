class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://ghproxy.com/https://github.com/protobuf-c/protobuf-c/releases/download/v1.4.1/protobuf-c-1.4.1.tar.gz"
  sha256 "4cc4facd508172f3e0a4d3a8736225d472418aee35b4ad053384b137b220339f"
  license "BSD-2-Clause"
  revision 10

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "899d76fd1efae4b2404a802994d3ff4d5ff74328ad84aa27602e113f0e84baa0"
    sha256 cellar: :any,                 arm64_ventura:  "f078402e98c0ed0893e7c45f270525d73af1fce025a29b7b7c28e97242e3a911"
    sha256 cellar: :any,                 arm64_monterey: "7a18c6c2e45d5290d915e319b57b835b8506fb41ca0d3d9f801ea6c2bdbacf14"
    sha256 cellar: :any,                 sonoma:         "d121a00c144164896118412cc3997418b1a1ce3f9922f63b7d70ac527d03237e"
    sha256 cellar: :any,                 ventura:        "26dc85759982d07178ea0db8d42e6848aee5c6615f0e651c37779f073a37549f"
    sha256 cellar: :any,                 monterey:       "3ff18ae10399d0a3f22425701e80d93cec1fddb9a97aca831283d5ed9cbcf7b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44ab9771ef7748e3d0a4b8c07eb0717b49a43cd5eba2b9deb490bc9a65a710a6"
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