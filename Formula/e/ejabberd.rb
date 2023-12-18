class Ejabberd < Formula
  desc "XMPP application server"
  homepage "https:www.ejabberd.im"
  url "https:github.comprocessoneejabberdarchiverefstags23.10.tar.gz"
  sha256 "0d6e7f0d82d91cda89e2575d99a83507413da2ffde39b2151804947a2a0fa258"
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
    sha256 cellar: :any,                 arm64_sonoma:   "794d8b7ad92d10302c4001c25e214af15184cfaa6ceec7612c35bfc7b25fe73d"
    sha256 cellar: :any,                 arm64_ventura:  "7565ed982ce7a6b4119b03e6cd39c3cb4f1a29b653f1d18e1a9ef6030dacea22"
    sha256 cellar: :any,                 arm64_monterey: "ccd32b5c508cf21404db647f2bccc2d5ba6d3625ccfd822deef642c4b69cdab5"
    sha256 cellar: :any,                 sonoma:         "a2cd6ff96f1618ff5545c9fc54b4e4fee1d5e58415a9b6755e6aad5d40e50bd5"
    sha256 cellar: :any,                 ventura:        "7bf04db46a8073fcb9b5b28ede1c8336653a99f17cc5225ed4cfa778f35be087"
    sha256 cellar: :any,                 monterey:       "39f3b3e165964307d733ab9a6003c3939c8e0c8617dd8c5b9f44921905ecc836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61d64ecc4dcd6c428e09a7a311b14ba8f90d36562243733e9722d0f2840aee64"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "erlang"
  depends_on "gd"
  depends_on "libyaml"
  depends_on "openssl@3"

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