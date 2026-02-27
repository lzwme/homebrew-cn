class MemtierBenchmark < Formula
  desc "Redis and Memcache traffic generation and benchmarking tool"
  homepage "https://github.com/RedisLabs/memtier_benchmark"
  url "https://ghfast.top/https://github.com/RedisLabs/memtier_benchmark/archive/refs/tags/2.2.2.tar.gz"
  sha256 "0a022f6d54b718b69c9d1342dbe7a2590d187575a22f5d13810bc8a0ac3ba215"
  license all_of: [
    "GPL-2.0-only",
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cd330b2ee5b361831eb3f7db5967ac7a56c83d32226820dbf48153a9ca15c214"
    sha256 cellar: :any,                 arm64_sequoia: "7aca5907a84936fa31953be1adaa91be5aae1bff706bca7a90b77a15e9cf9d60"
    sha256 cellar: :any,                 arm64_sonoma:  "d21e93cfda824aa217ea2f7b82ed7fb6c7b53660820f4a9d8ecfdb60d874442f"
    sha256 cellar: :any,                 sonoma:        "23541ae391f3bc4d61fe99b0b2d18aca23be0df01c489ab6fd55d8fcc4299e6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e06c30cbd3b096ba8e7942fc41357636e4473daa9f971f552befea05ca91705"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44c04faf18845e81f48fe29fb5c1ced7cbf3889d542b88ac847f09c5302df9dd"
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