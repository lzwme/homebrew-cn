class MemtierBenchmark < Formula
  desc "Redis and Memcache traffic generation and benchmarking tool"
  homepage "https://github.com/RedisLabs/memtier_benchmark"
  url "https://ghfast.top/https://github.com/RedisLabs/memtier_benchmark/archive/refs/tags/2.1.4.tar.gz"
  sha256 "11a16ce32bc96a21511ee38da5e10bec4b50323ff6735909c014e040b60f4db7"
  license all_of: [
    "GPL-2.0-only",
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fc0541dbbf7b5ef6718cfd9987c9e2aec14cd019466e510e5a8eb01f843bf262"
    sha256 cellar: :any,                 arm64_sonoma:  "a65fa7bdf21c0c0da72e55046c4872757950db7aae3a8312049246c57ea2e1b5"
    sha256 cellar: :any,                 arm64_ventura: "480d91ebdc73328c71a14fac3a89aef8b273e0ce4269ebee7338772c152f80f6"
    sha256 cellar: :any,                 sonoma:        "4a31a0c1a97bb0cad1281df5bbb4068051c2486e92bd6c5a0a9d44af1e39e225"
    sha256 cellar: :any,                 ventura:       "8ada137153c75deaa14f1e052d18a82b0252ad4eaeb569771a2c48adf33d1167"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f505c77b0c6639ccca30243e051a29fd0ce9ef9532c061e4c0733ecfe0236273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bc33bff6f485a4d924254a6c38243d048aa5b80b1a6c488f2cc767f38a758d2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "openssl@3"
  depends_on "pcre"

  uses_from_macos "zlib"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/memtier_benchmark --version")
    assert_match "ALL STATS", shell_output("#{bin}/memtier_benchmark -c 1 -t 1")
  end
end