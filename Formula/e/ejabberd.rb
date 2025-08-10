class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https://www.ejabberd.im"
  license "GPL-2.0-only"
  head "https://github.com/processone/ejabberd.git", branch: "master"

  stable do
    url "https://ghfast.top/https://github.com/processone/ejabberd/archive/refs/tags/25.07.tar.gz"
    sha256 "a980f2817ea03ca78dc5d8d241ba68a533cbcfe371996513a1b24ea371146596"

    # Backport fix for Erlang 28+
    patch do
      url "https://github.com/processone/ejabberd/commit/b1c3baa7bd283fe4616d4a9862fecd4f01e5bcea.patch?full_index=1"
      sha256 "669fe848e8445cc319965a4b23a568d8b8f82140c3bf5a6cd265f9067eac2f7b"
    end
  end

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "db37539ca1ebfe7a5aaceef1744eee4c4740e6ab6783e6af566b39628605a0b6"
    sha256 cellar: :any,                 arm64_sonoma:  "b2ae1a92f3f934483b7b11805a0913955b0daf930a0239d4a07c9111491529a0"
    sha256 cellar: :any,                 arm64_ventura: "9f71959ce29f30a08a128e9212900803297c21871f78d71c7f81c3a49698c5b9"
    sha256 cellar: :any,                 sonoma:        "14ce3a3f92b5c9e99734b79211ff1b07800d6da6371a6a04fa70570649da2a86"
    sha256 cellar: :any,                 ventura:       "7db64ee868ac575d19665f50bd2c76bd4fedb352c3c7d2a4defcb38c444e4b46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8490666703c18c63129043b0aa83586a62ee17ee959604dbc533a70965bddc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8eaf26880a8f89557773120718c802aa8c3f5a45db33db2e69eefabdf9f61b4"
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
    system sbin/"ejabberdctl", "ping"
  end
end