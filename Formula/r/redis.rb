class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-8.4.1.tar.gz"
  sha256 "859fe81b881f741843006eacf3e43d36b01af7ce3eabd5d7d2cb568533502162"
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
    sha256 cellar: :any,                 arm64_tahoe:   "01c7de487d2e4016de95ccd9c4ba250a61453b0ffa847b602023b8ea90847fc0"
    sha256 cellar: :any,                 arm64_sequoia: "7406bd552b4a6a935ccb1126da9651da2ad8e49a2830c40d071ba6608c5940df"
    sha256 cellar: :any,                 arm64_sonoma:  "fb6186ddf34a34c2a8afae26048d8e1134d6d0df5e0cae5b6c51eb6154dbcb98"
    sha256 cellar: :any,                 sonoma:        "6cf93b7d3d8af0d2a2f7a8b37f9020936207dd9a6278d2373b55595a28071955"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "938cd9e524c190470fd286b6c35d10b9193df8455f71594f761accc99234b759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f4e3804f9e3ce129f20207e3fd6a974ad561929a2f6c53821ba58608f56bdea"
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