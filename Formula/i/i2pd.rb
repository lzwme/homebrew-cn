class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://ghfast.top/https://github.com/PurpleI2P/i2pd/archive/refs/tags/2.57.0.tar.gz"
  sha256 "e2327f816d92a369eaaf9fd1661bc8b350495199e2f2cb4bfd4680107cd1d4b4"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dd5dbe37c54e64f03f2579dc2fdd873936ca4b2ce226d5f434c0c5a948b5749c"
    sha256 cellar: :any,                 arm64_sonoma:  "76d75af4900ea1f1012e7952047e960732c0c49dde9a0fdc93231061288766c8"
    sha256 cellar: :any,                 arm64_ventura: "c5f34119bf93d6795cdd02fd0de0fa05cbf17c1751f6d5a8c48f5219d7022adb"
    sha256 cellar: :any,                 sonoma:        "073711b48e78a6831294d2cbc4f2858f06f64b55c3f80d711cebd8cf1009d225"
    sha256 cellar: :any,                 ventura:       "a9e95f28d0e53c8ee3d0282b4c30d497a501d95d05da7deccfc46272ff4d5e64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f01280177ad65a820661628927d8168ad9ed660340fbab43ee082c1dbbf14acf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96d2090470bd78d7f4868228b981a2c444ffa7236ffd94cebddf50a77799a488"
  end

  depends_on "boost"
  depends_on "miniupnpc"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  # Backport fix for Boost 1.89.0
  patch do
    url "https://github.com/PurpleI2P/i2pd/commit/27f2c5285da9bec537caeba9f7df6920b9f21c87.patch?full_index=1"
    sha256 "008a59b2a78659b1eae746eeb3bf8635e8f12907741a9d951aebe552decc4a35"
  end

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
    rm_r(prefix/"etc")
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
    assert_path_exists testpath/"router.keys", "Failed to start i2pd"
    pid = pidfile.read.chomp.to_i
    begin
      Process.kill("TERM", pid)
    rescue Errno::ESRCH
      # Process already terminated
    end
  end
end