class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https:i2pd.website"
  url "https:github.comPurpleI2Pi2pdarchiverefstags2.56.0.tar.gz"
  sha256 "eb83f7e98afeb3704d9ee0da2499205f73bab0b1becaf4494ccdcbe4295f8550"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9b743c77e1ca36b5e51f811f752a13b559ac3b2b185f39dd85ada382cda78b77"
    sha256 cellar: :any,                 arm64_sonoma:  "978ec4c59d12433944167e47c412e5b2be6a62e51087628fc5a6f6803e9e898e"
    sha256 cellar: :any,                 arm64_ventura: "49fdefef843b41e568c256f88463aaea744e1fbfe726803369fbc136d0950270"
    sha256 cellar: :any,                 sonoma:        "1c53870d3e6ae38b9cc5b52726ad4d0aee8d171ead9757c4f9822c92e1a92caa"
    sha256 cellar: :any,                 ventura:       "a5c7eaa7c0a8e3425a75685222adde487d336e47e3f738fe6253941878a3a73a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d1c2cabd02eb7687871163a46410aea7ff8097698f86ff9a3c341a88f503c1f"
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
    begin
      Process.kill("TERM", pid)
    rescue Errno::ESRCH
      # Process already terminated
    end
  end
end