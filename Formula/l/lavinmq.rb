class Lavinmq < Formula
  desc "Message broker implementing the AMQP 0-9-1 and MQTT protocols"
  homepage "https://lavinmq.com"
  url "https://ghfast.top/https://github.com/cloudamqp/lavinmq/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "c5fed6406e48df516daa5b3dc29d8f6fae6549cb0971ed21293e197260c67879"
  license "Apache-2.0"
  head "https://github.com/cloudamqp/lavinmq.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6c1f82a97d86c1059d1977e80b4489bae9e08f8dbd974be89bd73e4bde95b276"
    sha256 cellar: :any,                 arm64_sequoia: "1f70f2bdfc38f3c9aad940b9afc3c8863805b513d11c51630b6082925bae865d"
    sha256 cellar: :any,                 arm64_sonoma:  "b94ca9941b1a89ebc4b8ba6615dda7a45c1f29b6e1e5d54e8e399928c43fe876"
    sha256 cellar: :any,                 sonoma:        "078b1eca126ff1e627b370f4bca322f060d26379655c40281e8f3cee0872235b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa631a3000645439ab06f4dfd2478be9269877ec1f5395bd53065bb1c2946cde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffe859dec88fe0ef3ee9798af0b446634e13e6f26fdbf7577e59defeafb8d3f1"
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
    ENV.prepend_path "PATH", Formula["coreutils"].opt_libexec/"gnubin" if OS.mac?

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