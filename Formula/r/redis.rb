class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "https://download.redis.io/releases/redis-7.2.2.tar.gz"
  sha256 "ca999be08800edc6d265379c4c7aafad92f0ee400692e4e2d69829ab4b4c3d08"
  license "BSD-3-Clause"
  head "https://github.com/redis/redis.git", branch: "unstable"

  livecheck do
    url "https://download.redis.io/releases/"
    regex(/href=.*?redis[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1f6146c802a15b65de4d650687b014ca43c46a85076e3edeb22d293522e5bbbc"
    sha256 cellar: :any,                 arm64_ventura:  "c412a9d0ac374696f8c563f0a2cdd57953f611447637c2e29120e7e3018050d7"
    sha256 cellar: :any,                 arm64_monterey: "4f9bc4c0688c92b4d6fd4cf786212f69071c4fa637febd3f9cdaa1d793583c98"
    sha256 cellar: :any,                 sonoma:         "7f690b472e683d20be5bebd16b9bf447f810371a94b92c2514f532b5a032acb1"
    sha256 cellar: :any,                 ventura:        "5183bf03eba3f2c85d5081ede7792d3db633bb72d0354008fe045c86c7576b2a"
    sha256 cellar: :any,                 monterey:       "93b090aed7c55898780b8a0a5d5c7bd91d520d178104f6c8a79c057c17fb5070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f080cae94a2f3a819b211483ddafe9307aa79146cb70a30be40772faf5859e64"
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