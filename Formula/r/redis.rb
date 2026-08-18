class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.10.1.tar.gz"
  sha256 "60166c95ab7aedaa9dfe516de685be0a4dd87be95ded59ba429df14c13f1b663"
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
    sha256 cellar: :any, arm64_tahoe:   "87425bbf403b3cfed368c98fdfa1843bc8aac2782cd40866c0f746514c9500c8"
    sha256 cellar: :any, arm64_sequoia: "1869cab0daecee40f96ba24194ce0fa6750e9117e0e8ce69f60af2caff1f3a78"
    sha256 cellar: :any, arm64_sonoma:  "7ad8a8b5baec8fe3d16064a80a2e11898c00042c17126952d68c66da9c9c2762"
    sha256 cellar: :any, sonoma:        "c3211f5ca728fbd8011efd491ddfff147b44de68d1e92fd23b571af6a83bd8fc"
    sha256 cellar: :any, arm64_linux:   "567a10a2fbe64c98d4256077129153375d27b10368abace2e15530ef3620d7d0"
    sha256 cellar: :any, x86_64_linux:  "f74de701676dca3682df9aa75bed1121de178ee63101547a3104c0bcf90486a0"
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