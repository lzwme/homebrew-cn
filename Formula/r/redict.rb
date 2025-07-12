class Redict < Formula
  desc "Distributed key/value database"
  homepage "https://redict.io/"
  url "https://codeberg.org/redict/redict/archive/7.3.4.tar.gz"
  sha256 "6c7e60b8b10a46f6fce8ccaaf1d6bf9d0db796a4d6169422c34dedbf8a4cb680"
  license "LGPL-3.0-only"
  head "https://codeberg.org/redict/redict.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b844f5012affe487e17f7cc9cfa01fa9583cdf1a0866950e2dac67b1d2fa4a5b"
    sha256 cellar: :any,                 arm64_sonoma:  "8bdbb8a22afb3781c2600ba4da73fc0df95885e6f1e3b2464b24e63ffb75207a"
    sha256 cellar: :any,                 arm64_ventura: "0311ce88486d0c261187b874cf1c69726b6b48c138f46f155b3ee578cba798a4"
    sha256 cellar: :any,                 sonoma:        "5d50b6e8ae05d93cc8bc60030977a530ba33652acdf9a71f98d6546910594bcc"
    sha256 cellar: :any,                 ventura:       "de694f4314360503a444759a53d6e1b33c81952c5ca2ddf9f7a03ff38a63d60a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9387d79e90d71278d27b0d5e337e7e70d456bb9d4be1f402d5bb531084a01a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f7d8d12a5288b1852e8c07bb109476620efbf9d84a89faa66dfd3dd222c424c"
  end

  depends_on "openssl@3"

  def install
    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes"

    %w[run db/redict log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redict.conf" do |s|
      s.gsub! "/var/run/redict_6379.pid", var/"run/redict.pid"
      s.gsub! "dir ./", "dir #{var}/db/redict/"
      s.sub!(/^bind .*$/, "bind 127.0.0.1 ::1")
    end

    etc.install "redict.conf"
    etc.install "sentinel.conf" => "redict-sentinel.conf"
  end

  service do
    run [opt_bin/"redict-server", etc/"redict.conf"]
    keep_alive true
    error_log_path var/"log/redict.log"
    log_path var/"log/redict.log"
    working_dir var
  end

  test do
    system bin/"redict-server", "--test-memory", "2"
    %w[run db/redict log].each { |p| assert_path_exists var/p, "#{var/p} doesn't exist!" }
  end
end