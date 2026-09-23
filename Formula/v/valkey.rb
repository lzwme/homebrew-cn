class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://ghfast.top/https://github.com/valkey-io/valkey/archive/refs/tags/9.1.2.tar.gz"
  sha256 "19c23908e7d57e8d91ef85b41f5646307582f10f4f0fb999bbf89ed24ec9c983"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  head "https://github.com/valkey-io/valkey.git", branch: "unstable"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "5b0ec8d457677eab77965c460a27782d7b76b36f99cddb8f5085904e813f024d"
    sha256 cellar: :any, arm64_tahoe:       "3319ebe198120ab55fa35f31aef84d164837b60cc7afd8dbc6ef43568762a113"
    sha256 cellar: :any, arm64_sequoia:     "da82708524bc70a3c03b2378b58cad08479ad7116eb0b6e7dfae260949534884"
    sha256 cellar: :any, arm64_linux:       "657e966d70191d25d7993f7f3214d6d60f0a93993088ce8e3ee71a7f27e335eb"
    sha256 cellar: :any, x86_64_linux:      "578578ab31dea1b183e1206d3817019466d56f27a94fa93f2e042072844863a0"
  end

  depends_on "openssl@4"

  conflicts_with "redis", because: "both install `redis-*` binaries"

  deny_network_access!

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