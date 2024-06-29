class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https:www.ejabberd.im"
  url "https:github.comprocessoneejabberdarchiverefstags24.06.tar.gz"
  sha256 "34ef56370d39bdc9a3c58d7775a65a2c1d4e8c52e6aa80e77a8435d414dda81e"
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
    sha256 cellar: :any,                 arm64_sonoma:   "02c537ebbd8b8df2830d5fd354a5e94e971cea9ffd13615060761c9e99a4b29f"
    sha256 cellar: :any,                 arm64_ventura:  "f2f9f0c671e879d11915cfac45e15025058409cfb4e076e87a0d2694da61bffc"
    sha256 cellar: :any,                 arm64_monterey: "97c5e3099fde54457a50c682f588f9f9c0224ab57a86e5dbc4cc4e779a54c54e"
    sha256 cellar: :any,                 sonoma:         "699ffa3a0a26c0741453d78f1f59d7e2c5f9c7d804fede88c6f1626f744bffc5"
    sha256 cellar: :any,                 ventura:        "8aae2081d21815c5e53b408328497bc3f14038bc0c2e63cfa8323c4b8e03ca0d"
    sha256 cellar: :any,                 monterey:       "c39b4e1b9ddb0209f9ac4248e94af28a927106c03d889b774808c3a2a93a6b4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b611f3387d22da8e86ca65f7d7db19269b832acc8f1c0e29f269e9c2a77e6326"
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