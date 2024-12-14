class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https:i2pd.website"
  # TODO: Switch to latest `boost` dependency on next release
  url "https:github.comPurpleI2Pi2pdarchiverefstags2.54.0.tar.gz"
  sha256 "5c3f703417bb5f3e5dda642d39c5d30593a5dcf69d5a5ecfe82d5e8a7d454aaf"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "03f7ef0703446cf80a96042dab3beb16f488642a68a236f159c52749cb7c2a2e"
    sha256 cellar: :any,                 arm64_sonoma:  "43d3909f37585ead0fe2e69e60fe1a42e0a1790a5cdb30e63255d439affd0256"
    sha256 cellar: :any,                 arm64_ventura: "878bf408b2fc44736d556b5c72138271a250ff8eaf5031375527adb4e1c5682c"
    sha256 cellar: :any,                 sonoma:        "023abd273cf210515299f43a9dfaeff5162701766879a76c26d2f04f82abbd7d"
    sha256 cellar: :any,                 ventura:       "e1b5269fb55c0a7c4546242372cd237d6a871823d6b20963701df023b7e0300c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "961729ac5256811419308cc208914789d309882ade25423df57bb77228d379aa"
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