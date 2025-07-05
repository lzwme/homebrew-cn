class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://ghfast.top/https://github.com/valkey-io/valkey/archive/refs/tags/8.1.2.tar.gz"
  sha256 "747b272191c15c7387f4ad3b3e7eda16deb1cffc6425e0571547f54e4d2e3646"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  head "https://github.com/valkey-io/valkey.git", branch: "unstable"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "156c0d4d0db6c0145ec5409f87d0f665da3a839e7b81f18ce2d7263415df4a34"
    sha256 cellar: :any,                 arm64_sonoma:  "d9d74e88181f14466989370495bc9330cde32f8636007243d336c4bb0f4c6752"
    sha256 cellar: :any,                 arm64_ventura: "3c0ce974ca464b56c4bfb825f3f387170166d2288c8d3573da91c39efd23ca35"
    sha256 cellar: :any,                 sonoma:        "5c971728a93ec03d571a6168c0362236e41ec3170655d7e699ee797a06a69793"
    sha256 cellar: :any,                 ventura:       "114890fb33120d4276554dba33ff9d02bd2f4ff05e0a8ad8d9437d96a47c216d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "154429d7c6606defb92b218d979231c34265fd68438fe8977161fffa94fddf11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eeb8f9c4b7c42a298de567302dc468c80a5492dc76b881e27eef6b6c54275aae"
  end

  depends_on "openssl@3"

  conflicts_with "redis", because: "both install `redis-*` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes"

    %w[run db/valkey log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "valkey.conf" do |s|
      s.gsub! "/var/run/valkey_6379.pid", var/"run/valkey.pid"
      s.gsub! "dir ./", "dir #{var}/db/valkey/"
      s.sub!(/^bind .*$/, "bind 127.0.0.1 ::1")
    end

    etc.install "valkey.conf"
    etc.install "sentinel.conf" => "valkey-sentinel.conf"
  end

  service do
    run [opt_bin/"valkey-server", etc/"valkey.conf"]
    keep_alive true
    error_log_path var/"log/valkey.log"
    log_path var/"log/valkey.log"
    working_dir var
  end

  test do
    system bin/"valkey-server", "--test-memory", "2"
    %w[run db/valkey log].each { |p| assert_path_exists var/p, "#{var/p} doesn't exist!" }
  end
end