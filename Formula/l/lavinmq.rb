class Lavinmq < Formula
  desc "Message broker implementing the AMQP 0-9-1 and MQTT protocols"
  homepage "https://lavinmq.com"
  url "https://ghfast.top/https://github.com/cloudamqp/lavinmq/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "f7e2ddd3110be9ece9821dd3ad9ebe9f82d142c8431105ea3ad0043b4b25619d"
  license "Apache-2.0"
  head "https://github.com/cloudamqp/lavinmq.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "bb662fb98849595e1ba05c7db1bf282d40e3e85db2e848644dbfb175fea5e791"
    sha256 cellar: :any, arm64_tahoe:       "bd0608afb10da597fc8d7b8728c813347167fd121cdef34cef8ac58b39a7de0e"
    sha256 cellar: :any, arm64_sequoia:     "6d645a78c27a33541cfa917e484abefedff7d2a2fc1953800c7c9142e9e933d1"
    sha256 cellar: :any, arm64_linux:       "fb29ed5c9973c0c9003ad398732b80a8699ac82be319ffa4dd35a8df55fa67b8"
    sha256 cellar: :any, x86_64_linux:      "bf5d4cc6fbc8763293812636e043b9972efd45b21742750634a6350767f36cee"
  end

  depends_on "crystal" => :build
  depends_on "help2man" => :build
  depends_on "bdw-gc"
  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "pcre2"

  on_macos do
    # GNU install (Makefile uses `install -D -t`); Linux's /usr/bin/install is already GNU.
    depends_on "coreutils" => :build
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    # Fetch the shards and the web UI's JavaScript libraries
    system "make", "lib", "js"
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
    ENV["LAVINMQCTL_CONTROL_UNIX_PATH"] = control_unix_path = testpath/"lavinmqctl.sock"
    # Disable the TCP listeners, which the network sandbox doesn't allow
    tcp_ports = %w[amqp http mqtt mqtts metrics-http].map { |listener| "--#{listener}-port=-1" }
    pid = spawn bin/"lavinmq", "--data-dir", testpath/"data", "--control-unix-path", control_unix_path, *tcp_ports
    30.times do
      break if control_unix_path.exist?

      sleep 1
    end
    output = shell_output("#{bin}/lavinmqctl status")
    assert_match "Uptime", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end