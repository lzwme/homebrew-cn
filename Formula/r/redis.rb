class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.2.0.tar.gz"
  sha256 "ff95b83b7cf2f7a33af3be1e52fdf2e791c259f8272465c3b09f9e6bc901b604"
  license all_of: [
    "AGPL-3.0-only",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ae6b3a796ad5c6ff9e6410d21cfa0f64fa6ee7b901d28c140ba2419fb0d66f70"
    sha256 cellar: :any,                 arm64_sonoma:  "da21c5f27f159a8cf1d4e6e2ae24ad0683c48c1412c3d29524752fe48f32dce0"
    sha256 cellar: :any,                 arm64_ventura: "da413469531dd09bd44c2aaedddd380d240a285d4e4e9d9a726142492ab40359"
    sha256 cellar: :any,                 sonoma:        "ddbc9e2648ab5348c60379b3e25ca3608b2ca5b51cb30dc053f135b11453496b"
    sha256 cellar: :any,                 ventura:       "e06b1a80db7732f582bc544e70d413c5f7b8aca1da4094ad2933a42138a12514"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "524d854c4e5dc5e90316cf36530b1b6d6a5c6ce36f4e8d12b6295940553a4c77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77fd0ee52c6ac0176a1e6f41fbd8439c1c447d77ec1a2e800eb1ccb20994c637"
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