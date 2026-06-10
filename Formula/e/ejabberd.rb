class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://ghfast.top/https://github.com/processone/ejabberd/archive/refs/tags/26.04.tar.gz"
  sha256 "77deb1053978ae9790f909b7b573ac61c6b94d7c465a84c5b56568292d49e47d"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/processone/ejabberd.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "03f174dd628778ecb6301a3dfbb6da50753b0eaf54d0dbc560e25c68c5a7a7e1"
    sha256 cellar: :any, arm64_sequoia: "e091fb3b4fe98311e3f797f3d9398536b5ab6881b0a62eedab54416776e45f7b"
    sha256 cellar: :any, arm64_sonoma:  "6399db0bfe396459c5ebcce340eebb75d2e3387c1acd17f1ea6caecc3d67ee87"
    sha256 cellar: :any, sonoma:        "0fc0e824efa7fae1687994fe2dc80eb9b3cb16e7711eae6eebc2e6f88cb3df65"
    sha256 cellar: :any, arm64_linux:   "d73d165f77d6a257b906fe80288bf14c7df6b378eae281cbf9965b892fc7abb7"
    sha256 cellar: :any, x86_64_linux:  "6bba2d33d568059eb7b91e7669b02216db9f7e46cad9226722720ca5f39e129e"
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
  end

  def post_install
    (var/"lib/ejabberd").mkpath
    (var/"spool/ejabberd").mkpath

    # Create the vm.args file, if it does not exist. Put a random cookie in it to secure the instance.
    vm_args_file = etc/"ejabberd/vm.args"
    unless vm_args_file.exist?
      require "securerandom"
      cookie = SecureRandom.hex
      vm_args_file.write <<~EOS
        -setcookie #{cookie}
      EOS
    end
  end

  def caveats
    <<~EOS
      If you face nodedown problems, concat your machine name to:
        /private/etc/hosts
      after 'localhost'.
    EOS
  end

  service do
    run [opt_sbin/"ejabberdctl", "start"]
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