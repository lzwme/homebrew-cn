class MemtierBenchmark < Formula
  desc "Redis and Memcache traffic generation and benchmarking tool"
  homepage "https://github.com/redis/memtier_benchmark"
  url "https://ghfast.top/https://github.com/redis/memtier_benchmark/archive/refs/tags/2.5.0.tar.gz"
  sha256 "1cdda9df157d27889fab283641f8c12e019663f2447c842fbed36f57ac3336a4"
  # https://github.com/redis/memtier_benchmark/blob/master/debian/copyright
  license all_of: [
    "GPL-2.0-or-later" => { with: "cryptsetup-OpenSSL-exception" },
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram/LICENSE.txt
  ]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5fb86a156519b27a05c6d0b5bb8080372f7cb74f1c9f106243140b57ded864fd"
    sha256 cellar: :any, arm64_sequoia: "283e8390c1296a33473d60df1dcdc168b901922e02b2823bed32926998ca37ed"
    sha256 cellar: :any, arm64_sonoma:  "8131029491bc388bfea31204f8d89bbdc97eaa8dfde206be05a52f0573211147"
    sha256 cellar: :any, sonoma:        "58115dde32a761aabaef9f8503928463000c89e409415dd183efad8871ba28dc"
    sha256 cellar: :any, arm64_linux:   "875bbd82f640aa52f8089fc166709218fa48abe01fb393db5799bdda2923b225"
    sha256 cellar: :any, x86_64_linux:  "f32dff3c46fc1e7c0c33c36bdb37d137f796cc7658732553d72e148d1e4dd728"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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