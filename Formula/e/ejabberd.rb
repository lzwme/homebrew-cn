class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https:www.ejabberd.im"
  url "https:github.comprocessoneejabberdarchiverefstags24.10.tar.gz"
  sha256 "e260de76fc75354cd302caf2281e5114fdd1120d4fa2f4d24ddb1785dc43e343"
  license "GPL-2.0-only"
  head "https:github.comprocessoneejabberd.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0bbac950dfba118fdd659cc5e07683c2629b0270b6d90db2600c57b37923618d"
    sha256 cellar: :any,                 arm64_sonoma:  "5ab452653cf526ab258a04fdc2fe199a101fabe2272b2e139da81215270c7eb0"
    sha256 cellar: :any,                 arm64_ventura: "8fe998a22abc61616d3dd493807e5471d24bf8a2dac2f51be3b51a6c255216c9"
    sha256 cellar: :any,                 sonoma:        "a363cd6e6f144c6cd32a6c73428d37d10de3858d098dd760a9fe959675b20d0e"
    sha256 cellar: :any,                 ventura:       "bcb096e871949aa6e4048e4a0f768267d44bc42019b92883a70d067200d58c0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40f1d051e1064f0127bc8090ae538c39eb1bf6fce8bc2a4af87c2c5b57cd8439"
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
    ENV["TARGET_DIR"] = ENV["DESTDIR"] = "#{lib}ejabberderlanglibejabberd-#{version}"
    ENV["MAN_DIR"] = man
    ENV["SBIN_DIR"] = sbin

    args = ["--prefix=#{prefix}",
            "--sysconfdir=#{etc}",
            "--localstatedir=#{var}",
            "--enable-pgsql",
            "--enable-mysql",
            "--enable-odbc",
            "--enable-pam"]

    system ".autogen.sh"
    system ".configure", *args

    # Set CPP to work around cpp shim issue:
    # https:github.comHomebrewbrewissues5153
    system "make", "CPP=#{ENV.cc} -E"

    ENV.deparallelize
    system "make", "install"

    (etc"ejabberd").mkpath
  end

  def post_install
    (var"libejabberd").mkpath
    (var"spoolejabberd").mkpath

    # Create the vm.args file, if it does not exist. Put a random cookie in it to secure the instance.
    vm_args_file = etc"ejabberdvm.args"
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
        privateetchosts
      after 'localhost'.
    EOS
  end

  service do
    run [opt_sbin"ejabberdctl", "start"]
    environment_variables HOME: var"libejabberd"
    working_dir var"libejabberd"
  end

  test do
    system sbin"ejabberdctl", "ping"
  end
end