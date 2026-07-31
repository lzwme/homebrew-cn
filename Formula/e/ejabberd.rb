class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://ghfast.top/https://github.com/processone/ejabberd/archive/refs/tags/26.07.tar.gz"
  sha256 "7b2e4efe2d5c867d2ced9cb1391731c5e6b9accd6f166ec71e734a3ae97813d7"
  license "GPL-2.0-or-later"
  head "https://github.com/processone/ejabberd.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e769dbab88dd58f72284bccb7280cc1e166cc846454462c99314bf77ed399811"
    sha256 cellar: :any, arm64_sequoia: "5df5e4dbac2dea0819f45f8eb0018fada9412b6fe6dcecec4f89b96c1a67f9d9"
    sha256 cellar: :any, arm64_sonoma:  "f6b6c8b5a211a9cc5066bfb86fd111edff8d7b2f2b1621167b3b391ac661c123"
    sha256 cellar: :any, sonoma:        "a8efc4ebbd54cd9bd21a9bd91eb95fe643805fbced8afd3fa868b6c6e0e912ac"
    sha256 cellar: :any, arm64_linux:   "c1f78a1806c789cfc275c3768f77f66277569161213c5bb3864b331977deef81"
    sha256 cellar: :any, x86_64_linux:  "1f306b0f5cfe56b8838e92a0e554842e0008a3bf2685623c030da0522487ae0b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "elixir"
  depends_on "erlang"
  depends_on "gd"
  depends_on "libyaml"
  depends_on "openssl@3"

  uses_from_macos "expat"

  on_sonoma :or_older do
    depends_on "coreutils" => :build # for sha256sum
  end

  on_linux do
    depends_on "linux-pam"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "couchdb", because: "both install `jiffy` lib"

  def install
    ENV["TARGET_DIR"] = ENV["DESTDIR"] = "#{lib}/ejabberd/erlang/lib/ejabberd-#{version}"
    ENV["MAN_DIR"] = man
    ENV["SBIN_DIR"] = sbin

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-debug
      --enable-pgsql
      --enable-mysql
      --enable-odbc
      --enable-pam
      --enable-system-deps
    ]

    system "./autogen.sh"
    system "./configure", *args

    # 26.03 Makefile runs `invites-deps` targets in parallel, which can race
    # on bootstrap zip extraction in non-interactive environments.
    ENV.deparallelize

    # Set CPP to work around cpp shim issue:
    # https://github.com/Homebrew/brew/issues/5153
    system "make", "CPP=#{ENV.cc} -E"

    system "make", "install"

    (etc/"ejabberd").mkpath
    (var/"lib/ejabberd").mkpath
    (var/"spool/ejabberd").mkpath
  end

  def caveats
    <<~EOS
      If you face nodedown problems, concat your machine name to:
        /private/etc/hosts
      after 'localhost'.
    EOS
  end

  service do
    run [opt_sbin/"ejabberdctl", "foreground"]
    environment_variables HOME: var/"lib/ejabberd"
    working_dir var/"lib/ejabberd"
  end

  test do
    node = "ejabberd_test_#{Process.pid}@localhost"

    ENV["EJABBERD_BYPASS_WARNINGS"] = "true"
    ENV["EJABBERD_CONFIG_PATH"] = testpath/"ejabberd.yml"
    ENV["SPOOL_DIR"] = testpath/"spool"
    ENV["LOGS_DIR"] = testpath/"log"

    (testpath/"spool").mkpath
    (testpath/"log").mkpath

    cp etc/"ejabberd/ejabberd.yml", testpath/"ejabberd.yml"
    inreplace testpath/"ejabberd.yml", "port: 1883", "port: #{free_port}"

    output_log = testpath/"output.log"
    pid = spawn(sbin/"ejabberdctl", "--node", node, "foreground", pgroup: true, [:out, :err] => output_log.to_s)
    sleep 5
    assert_equal "pong\n", shell_output("#{sbin}/ejabberdctl --node #{node} ping")
    refute_match(/ERROR/i, output_log.read)
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end