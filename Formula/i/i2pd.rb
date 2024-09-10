class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https:i2pd.website"
  url "https:github.comPurpleI2Pi2pdarchiverefstags2.53.1.tar.gz"
  sha256 "c6863d853905e7594ea661595ea591055f8f2f018b9b90507d5a43a6456188ea"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a4e7d4d4cbd93bee7bd27ca808684ec9568c14b1be7090c62fe6bc689985acad"
    sha256 cellar: :any,                 arm64_ventura:  "a58c579c861e964a648cad9eb2d593f866cc5d2cfbad9049b42b08a5830ed4be"
    sha256 cellar: :any,                 arm64_monterey: "ee32381a4a7c9ac7176dbb51e0a74f18e2f06eb59690c12527dceb74df1c6968"
    sha256 cellar: :any,                 sonoma:         "0e6a92be437ff23d7bee284230e20b8da857f1b62048a73b213e366002482493"
    sha256 cellar: :any,                 ventura:        "bb945682a876206475efe7e3ca26bfa5d670f76c3778a6fcab6a9338abe7a634"
    sha256 cellar: :any,                 monterey:       "edc0f028fd5f951512fd5b33f1ce8b1cd6c41a208367ac17c1629d8da42f438f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebfae0bea6e262521b9f2fd1d57adac740c4f94bf610959ce501010c2e3f802c"
  end

  depends_on "boost"
  depends_on "miniupnpc"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    args = %W[
      DEBUG=no
      HOMEBREW=1
      USE_UPNP=yes
      PREFIX=#{prefix}
      BREWROOT=#{HOMEBREW_PREFIX}
      SSLROOT=#{Formula["openssl@3"].opt_prefix}
    ]
    args << "USE_AESNI=no" if Hardware::CPU.arm?

    system "make", "install", *args

    # preinstall to prevent overwriting changed by user configs
    confdir = etc"i2pd"
    rm_r(prefix"etc")
    confdir.install doc"i2pd.conf", doc"subscriptions.txt", doc"tunnels.conf"
  end

  def post_install
    # i2pd uses datadir from variable below. If that path doesn't exist,
    # create the directory and create symlinks to certificates and configs.
    # Certificates can be updated between releases, so we must recreate symlinks
    # to the latest version on upgrade.
    datadir = var"libi2pd"
    if datadir.exist?
      rm datadir"certificates"
      datadir.install_symlink pkgshare"certificates"
    else
      datadir.dirname.mkpath
      datadir.install_symlink pkgshare"certificates", etc"i2pdi2pd.conf",
                              etc"i2pdsubscriptions.txt", etc"i2pdtunnels.conf"
    end

    (var"logi2pd").mkpath
  end

  service do
    run [opt_bin"i2pd", "--datadir=#{var}libi2pd", "--conf=#{etc}i2pdi2pd.conf",
         "--tunconf=#{etc}i2pdtunnels.conf", "--log=file", "--logfile=#{var}logi2pdi2pd.log",
         "--pidfile=#{var}runi2pd.pid"]
  end

  test do
    pidfile = testpath"i2pd.pid"
    system bin"i2pd", "--datadir=#{testpath}", "--pidfile=#{pidfile}", "--daemon"
    sleep 5
    assert_predicate testpath"router.keys", :exist?, "Failed to start i2pd"
    pid = pidfile.read.chomp.to_i
    Process.kill "TERM", pid
  end
end