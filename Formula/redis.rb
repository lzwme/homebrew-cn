class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-7.0.12.tar.gz"
  sha256 "9dd83d5b278bb2bf0e39bfeb75c3e8170024edbaf11ba13b7037b2945cf48ab7"
  license "BSD-3-Clause"
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9ff5688661993866a7a07172908466da206436dc14aea1031522438ac01feacb"
    sha256 cellar: :any,                 arm64_monterey: "6f241d7717d26da9cd931991d94af40c12bb56cbd5e4f819a92079f2f1b0cca7"
    sha256 cellar: :any,                 arm64_big_sur:  "850b84d77dc26cffa3b81fda408f911a148aa8e814e926ca4342fa89583ae137"
    sha256 cellar: :any,                 ventura:        "6aae34879ec42527a23db42e739d65dd6b5aaa7eb6b32799899357d3cfdd02b6"
    sha256 cellar: :any,                 monterey:       "d27f1e41bb6383a03f6c60657a63a70f0ee265e58f8f6efcb2df6f96ec582d86"
    sha256 cellar: :any,                 big_sur:        "8e4103613def796b0ef1fc3c0b2b091f0d00baffa30f84112c4dae9272970c5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "629240f5d87cab1d9f60ab0a8641eaf5da7720e4ef984bb7dfaf829b44c89d47"
  end

  depends_on "openssl@3"

  def install
    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes"

    %w[run db/redis log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis.pid", var/"run/redis.pid"
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
    %w[run db/redis log].each { |p| assert_predicate var/p, :exist?, "#{var/p} doesn't exist!" }
  end
end