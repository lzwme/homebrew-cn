class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https:i2pd.website"
  url "https:github.comPurpleI2Pi2pdarchiverefstags2.55.0.tar.gz"
  sha256 "f5792a1c0499143c716663e90bfb105aaa7ec47d1c4550b5f90ebfc25da00c6c"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "c49f0ffa26b0444d64c8824d2c9c3a2a1abd2a9a92cd3b3ff8efd77231d17012"
    sha256 cellar: :any,                 arm64_sonoma:  "727a719e890ff0ae5f2df28c004e05f3e7c97fb38950316249a3fcf5b8e9a818"
    sha256 cellar: :any,                 arm64_ventura: "7b27b8203bea735c2ecbfd24399e6623c0bda4cde36d5c52edfe8591d90fdc98"
    sha256 cellar: :any,                 sonoma:        "d093800a9dcdf0a6ed9f7118be1706917e3a0a006ae6029c2a9715ea3cb49cc0"
    sha256 cellar: :any,                 ventura:       "e67d1f9f5dfda2d3c9788c84f6134ca980aca1907dec76433ddef1973f20d059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8a7f79d76d991b3900f7812212f1e6fcec5a56893666f21f0c2329b308c9a41"
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
    assert_path_exists testpath"router.keys", "Failed to start i2pd"
    pid = pidfile.read.chomp.to_i
    Process.kill "TERM", pid
  end
end