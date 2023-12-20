class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https:i2pd.website"
  url "https:github.comPurpleI2Pi2pdarchiverefstags2.50.0.tar.gz"
  sha256 "67c8ba5ea03b09fe2a85820f6d5b3025ad6c4301cbca3fa44c0accfbe5c7def7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fedd0924f94ddbf0c6d4a9d7ca2900659e1d2e36c94b77cd1f54d8185d14f2dd"
    sha256 cellar: :any,                 arm64_ventura:  "84c3df66b2aeb60c94de7e540be807fe235eae9c804484e7b8f19517257f77d6"
    sha256 cellar: :any,                 arm64_monterey: "2282e2b9739cfc8e3d3742e17d0c5dedaeb6fa1df1beced0bb1e36c3714de6da"
    sha256 cellar: :any,                 sonoma:         "8055884f603d421bfca1727bcb22d8cfe4c1368601bc1406c53c9b64db77c6c5"
    sha256 cellar: :any,                 ventura:        "abca710eb2397a77e994146861c51ed8385f695244fa77c2bc0af28250527f2f"
    sha256 cellar: :any,                 monterey:       "d71b6903aa2249bbf271ff5559a1c0a827911f289d0f5f7c01095d98f48dfe9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74bb1cf6a137be2aa8ba49fbfd0ab0858ab4e7cbe77bd0ec4aea40e41fe5fd20"
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