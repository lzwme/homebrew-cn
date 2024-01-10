class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https:i2pd.website"
  url "https:github.comPurpleI2Pi2pdarchiverefstags2.50.2.tar.gz"
  sha256 "ae2ec4732c38fda71b4b48ce83624dd8b2e05083f2c94a03d20cafb616f63ca5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3678ffdef84a9c956a2841cc5732b09d2005ae62f08d9f6e43f6e53c4d3d8e58"
    sha256 cellar: :any,                 arm64_ventura:  "7c6a1fd119debdb361779bf04d4c981b702fec3126ddd03bd0f8183c7a9089b2"
    sha256 cellar: :any,                 arm64_monterey: "89ad015e1a8e019aec377e9b38f46040c59f06c36d8748ecb458b679ba2ab1bf"
    sha256 cellar: :any,                 sonoma:         "10319fa2d92f8af3027e3344ea2b1b3726fe19b6105da46c363ef107bda36433"
    sha256 cellar: :any,                 ventura:        "7aa7cc2ac848fca094bf07ee07a1d4d4ffec8117837bab5f40c11cca9240bbc7"
    sha256 cellar: :any,                 monterey:       "ae259d78c28e4c9eba57362761281fd4890ad248f98ea4b1405b7a3277ae4c80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1398396e532c39b6077e614373723225dc30e2f040c9a1e9def5670be5b9aae"
  end

  depends_on "boost"
  depends_on "miniupnpc"
  depends_on "openssl@3"

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
    rm_rf prefix"etc"
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