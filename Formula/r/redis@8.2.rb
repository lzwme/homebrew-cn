class RedisAT82 < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.2.8.tar.gz"
  sha256 "01354ee4449e758e6e45d056fe5802abd9ccde4d669b79c9d5e9f6d730a80759"
  license all_of: [
    "AGPL-3.0-only",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(8\.2(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fc5fdde1fe0a6576b37e877f522a58ec236d9d83df796ed3843b4f1bde2c1677"
    sha256 cellar: :any, arm64_sequoia: "27a42a5e36e84026425c6453c13bb684ee86cd074f78ffbaa3662741fde2a91b"
    sha256 cellar: :any, arm64_sonoma:  "34e440cc92b1bb7e99fb257ee060340c9c38d848a4c4843fa3c5fb1008164bc2"
    sha256 cellar: :any, sonoma:        "cc77e037be9c38e779a96ee3e978d1d4d4ef850c8d5a8f8356946546d7131f0e"
    sha256 cellar: :any, arm64_linux:   "98466e0cc12491a1af282c492f494c5b13fce18844afe394ac475af5727418b2"
    sha256 cellar: :any, x86_64_linux:  "b9e1144d3ac3f4ccaf3ee1e4ae67a6c246b248507515991769210bb1b7fcd145"
  end

  keg_only :versioned_formula

  depends_on "openssl@4"

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