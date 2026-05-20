class Valkey < Formula
  desc "High-performance data structure server that primarily serves key/value workloads"
  homepage "https://valkey.io"
  url "https://ghfast.top/https://github.com/valkey-io/valkey/archive/refs/tags/9.1.tar.gz"
  sha256 "9f872fb2510512e46839a7214d3fbbd4588c7636ec75ce0da2be751fddcc321c"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause", # deps/jemalloc, deps/linenoise, src/lzf*
    "BSL-1.0", # deps/fpconv
    "MIT", # deps/lua
    any_of: ["CC0-1.0", "BSD-2-Clause"], # deps/hdr_histogram
  ]
  head "https://github.com/valkey-io/valkey.git", branch: "unstable"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eaf022f9967f3faf61f6579975ddebda41b293af38060a2e66c54e04480c7795"
    sha256 cellar: :any,                 arm64_sequoia: "1f8ff0f0c9c17a3e6360d7b6b7ef4b2c895c6e2c4a2646a42e84172fe40b2a66"
    sha256 cellar: :any,                 arm64_sonoma:  "40d1f268a38e4ef9dd1efded34b14082827156c92d2910b5ecc17c0efd3a3cd9"
    sha256 cellar: :any,                 sonoma:        "2f2d75bf8c82685d66a5e7e083299ad9f5a47c30d51e33e40303d3b613317801"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2253f237df4ea9bf9626363ba83855a9bea45f34f5f8f8eb33cd71c8ccf9d909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da0cacd813a65fded56561a5ccd7e78d57c9ee10b4774b08bd826f3a48874153"
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