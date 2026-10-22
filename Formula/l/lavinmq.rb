class Lavinmq < Formula
  desc "Message broker implementing the AMQP 0-9-1 and MQTT protocols"
  homepage "https://lavinmq.com"
  url "https://ghfast.top/https://github.com/cloudamqp/lavinmq/archive/refs/tags/v2.10.3.tar.gz"
  sha256 "f9e8e54f6d4b7b9d46a84037fc155343d6fcff10690a015f92dcc9cc1df45c50"
  license "Apache-2.0"
  head "https://github.com/cloudamqp/lavinmq.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f3093ad6162b546fa75a9cd4ff872a63d0d29ced25d8c61eea879e989abfbe35"
    sha256 cellar: :any, arm64_tahoe:       "d25002b3680f13254658a1761357c2af8659975e32da07f39e8f0428f557ab44"
    sha256 cellar: :any, arm64_sequoia:     "f27d3facdffa2663e9a995c623c2099f3043e9a72323a77316942f76f1a6122c"
    sha256 cellar: :any, arm64_linux:       "fd3daeebf3524a921a15bdcf6cdf4f5b5faa682c9aa6c52c50201e96b9237189"
    sha256 cellar: :any, x86_64_linux:      "36294989110bffc1094df92e08415fde0eeb0727962f072d2241e76f8dbc1f8b"
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