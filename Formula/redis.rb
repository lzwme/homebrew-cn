class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-7.0.10.tar.gz"
  sha256 "1dee4c6487341cae7bd6432ff7590906522215a061fdef87c7d040a0cb600131"
  license "BSD-3-Clause"
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9e4bc4d6ec509e009a399a6b67e0c55b7c17daaf24d6bb558a845d149e5d85b2"
    sha256 cellar: :any,                 arm64_monterey: "8879694ee912ed40499ee88b8a58c850a802a746117899805a1b88ba3c677bd0"
    sha256 cellar: :any,                 arm64_big_sur:  "297a8877586a6efee3598ff70c9e52b1c37705411a6d919c70a2b35a168fac07"
    sha256 cellar: :any,                 ventura:        "9eb51d719e6e7268d65af695ebd50796f18f28c4108ef57b4d23b6d7724a1d49"
    sha256 cellar: :any,                 monterey:       "0fc891790c26f5452ec3ab88aa13f3ec3c0dbcc4fe914e81988e78695b1baac7"
    sha256 cellar: :any,                 big_sur:        "c07cf934ac442ab91938a1df4f9f4b160c7b9db044dac89bdad165882dd14fbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38e7cd7f61a9c26d36360692384512da9e8e5b42de46738c09ea8c59f44294c9"
  end

  depends_on "openssl@1.1"

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