class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https:i2pd.website"
  # TODO: Switch to latest `boost` dependency on next release
  url "https:github.comPurpleI2Pi2pdarchiverefstags2.55.0.tar.gz"
  sha256 "f5792a1c0499143c716663e90bfb105aaa7ec47d1c4550b5f90ebfc25da00c6c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "90d8ccd4ba31afcfcc690fac21c3a0946699916d5e22964e112b0149efcceabf"
    sha256 cellar: :any,                 arm64_sonoma:  "cd91388ea4cb59b3b6e005d96b85c48c8c75fb6a5beaba36a13884fd28e87bd7"
    sha256 cellar: :any,                 arm64_ventura: "ca57f6a6a9aac905ba794ef8a045eebba9a7ae2d7c13c03f2e2a62de308a5e87"
    sha256 cellar: :any,                 sonoma:        "c35e53ab939669eac762f82441d880f58ca3ece6bcd82d2390b228522b54e795"
    sha256 cellar: :any,                 ventura:       "83259ed270c54b04e910ba8ece73b10b82d2acb6214859accfdd1526727329e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a016bfda13fa3b5deba1948edec9ee979b3fc2c90b226826c36600b9e0d20d9e"
  end

  depends_on "boost@1.85"
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