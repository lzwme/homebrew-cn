class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.8.1.tar.gz"
  sha256 "1d1e423c9c808de3cb01dd3300d2b8d305b7691382e31a847ec17b66d3157477"
  license all_of: [
    "AGPL-3.0-only",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  compatibility_version 1
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5d134b844d66f6f35046e7ffb0ad5b4019da30fcf4a705704ad27829e783d5e1"
    sha256 cellar: :any, arm64_sequoia: "46c5915ee4e8335544b32b1ef89aba7ddeca3d8adae100ea17e9d9a1f3e039ef"
    sha256 cellar: :any, arm64_sonoma:  "03f685dc027fd5023e4d431b3c2244de34ec35d660d694a97126b8a19f971591"
    sha256 cellar: :any, sonoma:        "ff6253516ff4cab9343a71a9ba54548071b0d1bb87310fdb7540b345fc9867b5"
    sha256 cellar: :any, arm64_linux:   "70088163dc09278f66eee05a5734351dd038f33d59c88726670dc75419b6e92d"
    sha256 cellar: :any, x86_64_linux:  "56d4c3993a9fa8d734d119d147df94fb5a9448f5a65045e94e7e57217f640026"
  end

  depends_on "openssl@3"

  conflicts_with "valkey", because: "both install `redis-*` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes"

    %w[run db/redis log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis_6379.pid", var/"run/redis.pid"
      s.gsub! "dir ./", "dir #{var}/db/redis/"
      s.sub!(/^bind .*$/, "bind 127.0.0.1 ::1")
    end

    etc.install "redis.conf"
    etc.install "sentinel.conf" => "redis-sentinel.conf"
  end

  service do
    run [opt_bin/"redis-server", etc/"redis.conf"]
    keep_alive true
    error_log_path var/"log/redis.log"
    log_path var/"log/redis.log"
    working_dir var
  end

  test do
    system bin/"redis-server", "--test-memory", "2"
    %w[run db/redis log].each { |p| assert_path_exists var/p, "#{var/p} doesn't exist!" }
  end
end