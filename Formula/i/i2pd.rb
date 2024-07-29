class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https:i2pd.website"
  url "https:github.comPurpleI2Pi2pdarchiverefstags2.53.0.tar.gz"
  sha256 "a5eb7f9faa7a8b66b044841e2967b9dc0367e4e41939ce6a3223f8bd2f347da8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f65ba9dcbb03a5c6df32717c7081b14f42f9a2c9412f8cfb65691961ed8207f1"
    sha256 cellar: :any,                 arm64_ventura:  "c7b12e7dbeadcc3dc7665e43f7cf85c041c0c038acddcf0b90877cf47e065054"
    sha256 cellar: :any,                 arm64_monterey: "1f94b327cda9cfbae5a5d4ff5e7ec8603856e16af8fcb8576f26f80aa9778de0"
    sha256 cellar: :any,                 sonoma:         "634caa584e9c56c2e92fcc174b0fc795405413e4c3917d0215fa3f2b3f9bc112"
    sha256 cellar: :any,                 ventura:        "007a1756c89651e2c894bb8bace7891057edcdf59ce5a437cb2526543b54f049"
    sha256 cellar: :any,                 monterey:       "422d936d98fd77215d547c6a1a4ce613a470bdcec9c4d073c128516401142dba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a102eb020eda421abf841b1e8773c8ff6efab9d84538381a9762a11b215ef443"
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