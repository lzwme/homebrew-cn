class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://ghproxy.com/https://github.com/PurpleI2P/i2pd/archive/2.47.0.tar.gz"
  sha256 "c988baf23215c37d5f566b7b2059a3c168c78d157eac6dc04a30ac266c6335f0"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0db91ae1ee0475a58573d0ce4fc27756e85dcb13dd442078e1a9479135e88faf"
    sha256 cellar: :any,                 arm64_monterey: "5fb20e264cd4a7601bade83084d4d09823d458b1c219645d23f5811e7c40a5fb"
    sha256 cellar: :any,                 arm64_big_sur:  "ee3c316bb78aabf76268227c62be2f7c3b02052ff630be1a9493bac7f9991544"
    sha256 cellar: :any,                 ventura:        "47affd84bea74971780c57d9e93a1b8e795cdb058af09a7f865995ed04967092"
    sha256 cellar: :any,                 monterey:       "d064d3dc0122e493acb01522c656773d781a51a94c3ad387d322cc4d7376bdff"
    sha256 cellar: :any,                 big_sur:        "5597676dfec0fbd1d74693b2b25c30e71c120723f985a8924ab5eccf1d00a416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "483f5e7cfaa1965b308f5e3d6baff6a5ab0025739d714262fc9575f54d175d0d"
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
    confdir = etc/"i2pd"
    rm_rf prefix/"etc"
    confdir.install doc/"i2pd.conf", doc/"subscriptions.txt", doc/"tunnels.conf"
  end

  def post_install
    # i2pd uses datadir from variable below. If that path doesn't exist,
    # create the directory and create symlinks to certificates and configs.
    # Certificates can be updated between releases, so we must recreate symlinks
    # to the latest version on upgrade.
    datadir = var/"lib/i2pd"
    if datadir.exist?
      rm datadir/"certificates"
      datadir.install_symlink pkgshare/"certificates"
    else
      datadir.dirname.mkpath
      datadir.install_symlink pkgshare/"certificates", etc/"i2pd/i2pd.conf",
                              etc/"i2pd/subscriptions.txt", etc/"i2pd/tunnels.conf"
    end

    (var/"log/i2pd").mkpath
  end

  service do
    run [opt_bin/"i2pd", "--datadir=#{var}/lib/i2pd", "--conf=#{etc}/i2pd/i2pd.conf",
         "--tunconf=#{etc}/i2pd/tunnels.conf", "--log=file", "--logfile=#{var}/log/i2pd/i2pd.log",
         "--pidfile=#{var}/run/i2pd.pid"]
  end

  test do
    pidfile = testpath/"i2pd.pid"
    system bin/"i2pd", "--datadir=#{testpath}", "--pidfile=#{pidfile}", "--daemon"
    sleep 5
    assert_predicate testpath/"router.keys", :exist?, "Failed to start i2pd"
    pid = pidfile.read.chomp.to_i
    Process.kill "TERM", pid
  end
end