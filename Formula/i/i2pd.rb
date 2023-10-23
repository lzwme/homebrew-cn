class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://ghproxy.com/https://github.com/PurpleI2P/i2pd/archive/2.49.0.tar.gz"
  sha256 "d8e07f78cc9f1ba65e8460db27c649dd0cfdd3ba334725f8d6f9ee815cb40e68"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3c5f91b45bd3ae82d543d1c5343312c27aabfa7b8df415a1d7df8483fdf8cc28"
    sha256 cellar: :any,                 arm64_ventura:  "ff7af6fe06ee01e7010eef65bed7ee3e9cb1724424973d2b530a57d4c6c1554a"
    sha256 cellar: :any,                 arm64_monterey: "86da15510b20431a56053e0a8d61ae2d2098af1833c2e6488a07cbb48e5686d9"
    sha256 cellar: :any,                 sonoma:         "fa99d75dc9f3d165347c7adf8cd79198be295420f5527a860c7e9a1c2c462d1c"
    sha256 cellar: :any,                 ventura:        "984568f33af0e93d5c8adbcacc2211ef9c6e34946370ac7c4e19ecd633d13a05"
    sha256 cellar: :any,                 monterey:       "1f7ba02391ee429c059489673ede9d4f5354220e43d83b55dfa313edcd2c6791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bd15e8f62ec4b7c090fae10801fa2d3d7511f58074e7d6bf80dbc1a20a3ccb5"
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