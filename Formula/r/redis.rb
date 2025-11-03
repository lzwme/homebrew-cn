class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.2.3.tar.gz"
  sha256 "d88f2361fdf3a3a8668fe5753e29915566109dca07b4cb036427ea6dc7783671"
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
    sha256 cellar: :any,                 arm64_tahoe:   "8b454b70a1a3581d8ea5518c293f57251a2c51d783729166547d48f9cb7cbca5"
    sha256 cellar: :any,                 arm64_sequoia: "91f25248c9f275ef00867f7aae626d2e777c3a48ed1db5616794922922ee7c3c"
    sha256 cellar: :any,                 arm64_sonoma:  "2ff55d93725a84033ded160bf42c8bae793d8c5ee460542f4311b814adf2f3ac"
    sha256 cellar: :any,                 sonoma:        "b49f9175649a0c72786d614f655f9fd6c34d4af86f3cbaf206eeda91c6fe0d5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a40c9bbbbd903f6d63de4a89cc3e101366aad5a2c24c75f335e10ce512ef2268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bafdd2640eb41d4039ce83a7f1a0f67d89c13700a95d643c4061250741302736"
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