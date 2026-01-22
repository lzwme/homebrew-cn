class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  url "https://ghfast.top/https://github.com/processone/ejabberd/archive/refs/tags/26.01.tar.gz"
  sha256 "ccdb8efc9e9a93d547848df8df10c7d4953187e8409a20e389a0fb35a4d7176c"
  license "GPL-2.0-only"
  head "https://github.com/processone/ejabberd.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e52391f4eb6214faa508f8a9c06b09db0dcee3c2556337412a54d0732009c886"
    sha256 cellar: :any,                 arm64_sequoia: "8b0caf472cf1ffb0fa2f8194e80b81f493b9537518505cb2d1e656cb7b82b328"
    sha256 cellar: :any,                 arm64_sonoma:  "43163a3a736232611782585f30b4ff76aa8d840c053a04dc8897d11255ddefdd"
    sha256 cellar: :any,                 sonoma:        "8ee21deb91fc91aec93105f07d9b9bdfb15b835b6d11e9552a6ff2d14cdb12c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a04b42070cfef6e56115a5095675c2eabe6e2106c2518f5afaa68f8a13a0e258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a03d150f061f863bde609840faa726ba7f745d80cfffeb89d53ddaeda9de2c3b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "erlang"
  depends_on "gd"
  depends_on "libyaml"
  depends_on "openssl@3"

  uses_from_macos "expat"

  on_linux do
    depends_on "linux-pam"
  end

  conflicts_with "couchdb", because: "both install `jiffy` lib"

  def install
    ENV["TARGET_DIR"] = ENV["DESTDIR"] = "#{lib}/ejabberd/erlang/lib/ejabberd-#{version}"
    ENV["MAN_DIR"] = man
    ENV["SBIN_DIR"] = sbin

    args = ["--prefix=#{prefix}",
            "--sysconfdir=#{etc}",
            "--localstatedir=#{var}",
            "--enable-pgsql",
            "--enable-mysql",
            "--enable-odbc",
            "--enable-pam"]

    system "./autogen.sh"
    system "./configure", *args

    # Set CPP to work around cpp shim issue:
    # https://github.com/Homebrew/brew/issues/5153
    system "make", "CPP=#{ENV.cc} -E"

    ENV.deparallelize
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
    ENV["EJABBERD_BYPASS_WARNINGS"] = "true"
    ENV["EJABBERD_CONFIG_PATH"] = testpath/"ejabberd.yml"

    cp etc/"ejabberd/ejabberd.yml", testpath/"ejabberd.yml"
    inreplace testpath/"ejabberd.yml", "port: 1883", "port: #{free_port}"

    pid = spawn sbin/"ejabberdctl", "foreground"
    sleep 1
    system sbin/"ejabberdctl", "ping"
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end