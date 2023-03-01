class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://ghproxy.com/https://github.com/PurpleI2P/i2pd/archive/2.46.1.tar.gz"
  sha256 "76b41d02a41a03d627fcd7fe695cad7f521b66e99a04ec9678f132a1eb052bb8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "aea0a9cf171befb1f9d115cd77e8b6e8a32e99c91743b58bbea9c96129f33578"
    sha256 cellar: :any,                 arm64_monterey: "35a429b86c613e1381bc858846d7738922f029ba97e9b312d63a14dfab16a4d2"
    sha256 cellar: :any,                 arm64_big_sur:  "843fb1398b4292d392a0324cf8d26062e32498700632245846191f1ed369bba3"
    sha256 cellar: :any,                 ventura:        "61ba19b6ffb89d39fe01dfe4b3b8a368d0cc297405e8a54073da862db4315810"
    sha256 cellar: :any,                 monterey:       "b61b04827b109d42cae634627b30943e792a1275988ccbfeb4cf1c5cc495aae9"
    sha256 cellar: :any,                 big_sur:        "cae86090b95998bba5e881915bccdb21406fef73efdb95d164d41efb0f2b1a81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fbbb08c51c3ff20a5c2ddac331bb7f929d68a272ecf14662e2924aae7e231bd"
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