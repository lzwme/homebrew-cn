class MemtierBenchmark < Formula
  desc "Redis and Memcache traffic generation and benchmarking tool"
  homepage "https://github.com/RedisLabs/memtier_benchmark"
  url "https://ghfast.top/https://github.com/RedisLabs/memtier_benchmark/archive/refs/tags/2.4.2.tar.gz"
  sha256 "906163dce897c1d94dbe4611ec0425f709a96d59eb7a42997b838b7c18b2b292"
  # https://github.com/redis/memtier_benchmark/blob/master/debian/copyright
  license all_of: [
    "GPL-2.0-or-later" => { with: "cryptsetup-OpenSSL-exception" },
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram/LICENSE.txt
  ]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a8281315d42980cc137c256ea3f30e9e2769cd2401ab95d0113507f94d9a0177"
    sha256 cellar: :any, arm64_sequoia: "e3d26f318408390e3186ced57a507bb4c73a083139638d92835679d4d6bbaadb"
    sha256 cellar: :any, arm64_sonoma:  "948d8355128c38d26eb8b54ed57987cb7e31f7f9208e69d2f31ebb10366c4d02"
    sha256 cellar: :any, sonoma:        "cf2120997e57419bf24092b8fa32b4618ecf93e536f6a7a2515e197e950e1954"
    sha256 cellar: :any, arm64_linux:   "d1afa7553451f3c8ceceb6be1e238c79fd400236327a156ebb6c8df0ce73c0bd"
    sha256 cellar: :any, x86_64_linux:  "92ce9ffcb0cfc4c5cf03a5d0b0fcf781e8e45eb1a4f4e1233281256ebddfafdc"
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