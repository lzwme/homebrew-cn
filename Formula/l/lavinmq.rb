class Lavinmq < Formula
  desc "Message broker implementing the AMQP 0-9-1 and MQTT protocols"
  homepage "https://lavinmq.com"
  url "https://ghfast.top/https://github.com/cloudamqp/lavinmq/archive/refs/tags/v2.8.2.tar.gz"
  sha256 "f9241ee9e45b65db9923e85d80de705c1873fac41ad02795d440fcc629c3ed60"
  license "Apache-2.0"
  head "https://github.com/cloudamqp/lavinmq.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bc3468369b1c1c5a7a43cc26603782f300e064abab85e3734ca474da3501003e"
    sha256 cellar: :any, arm64_sequoia: "e55bc558553f7a4156ba674068f622e66c4eae0765a29f0523c65a5133fc3032"
    sha256 cellar: :any, arm64_sonoma:  "1fc348fc043f9ed038b926958a8446de901e756d9812624fabe4961c24cb8c91"
    sha256 cellar: :any, sonoma:        "cf0da37bde4181383b2eb49ce060fcb81e286d67ccbefa3941abfecf7b92b3f5"
    sha256 cellar: :any, arm64_linux:   "1594da570d91f54d0dc27fe53ad3a9487b5057c45eb93baf53ee73073fe98b0a"
    sha256 cellar: :any, x86_64_linux:  "bbef6298b4eba84371efcb71611b30e9a420b02ff6a92a1e392dd4b3ff0dddeb"
  end

  depends_on "crystal" => :build
  depends_on "help2man" => :build
  depends_on "bdw-gc"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "pcre2"

  on_macos do
    # GNU install (Makefile uses `install -D -t`); Linux's /usr/bin/install is already GNU.
    depends_on "coreutils" => :build
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.prepend_path "PATH", formula_opt_libexec("coreutils")/"gnubin" if OS.mac?

    inreplace "extras/lavinmq.ini", /^data_dir.*/, "data_dir = #{var}/lavinmq"

    system "make", "install",
           "DOCS=",
           "PREFIX=#{prefix}",
           "SYSCONFDIR=#{buildpath}/stage/etc",
           "UNITDIR=#{buildpath}/stage/systemd",
           "SYSUSERSDIR=#{buildpath}/stage/sysusers",
           "SHAREDSTATEDIR=#{buildpath}/stage/var"

    pkgetc.install "extras/lavinmq.ini"
  end

  service do
    run [opt_bin/"lavinmq", "-c", etc/"lavinmq/lavinmq.ini"]
    keep_alive true
  end

  test do
    pid = spawn bin/"lavinmq", "--data-dir", testpath/"data"
    30.times do
      break if File.exist?("/tmp/lavinmqctl.sock")

      sleep 1
    end
    output = shell_output("#{bin}/lavinmqctl status")
    assert_match "Uptime", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end