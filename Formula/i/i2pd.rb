class I2pd < Formula
  desc "Full-featured C++ implementation of I2P client"
  homepage "https://i2pd.website/"
  url "https://ghfast.top/https://github.com/PurpleI2P/i2pd/archive/refs/tags/2.61.0.tar.gz"
  sha256 "409cd3c0257491286611ab6aaf690940c7248fb898377c13fadb65a836e2a0ab"
  license "BSD-3-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "f9b045848be1b25adaf05a91d5b92e4f98231a784563824c6396cec496eb61d9"
    sha256 cellar: :any, arm64_tahoe:       "eba1e18fb8fcc359e488ad38534ac074354329ea20f6254ddb20efb974846fb6"
    sha256 cellar: :any, arm64_sequoia:     "d8e2f6a38996467a0cae0c3bd5439747359fb630724b66b74b6872668b3af783"
    sha256 cellar: :any, arm64_linux:       "3372018cc4fdc11805b2ec6a2835b10930c3e792854ecb1dc261b1b6a6c54872"
    sha256 cellar: :any, x86_64_linux:      "ff2e8d6b2368f1613f0f913f5b37d6f8c9d5092f1318fd91b5f8e9765aff790f"
  end

  depends_on "boost"
  depends_on "miniupnpc"
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = %W[
      DEBUG=no
      HOMEBREW=1
      USE_UPNP=yes
      PREFIX=#{prefix}
      BREWROOT=#{HOMEBREW_PREFIX}
      SSLROOT=#{formula_opt_prefix("openssl@4")}
    ]
    args << "USE_AESNI=no" if Hardware::CPU.arm?

    system "make", "install", *args

    # preinstall to prevent overwriting changed by user configs
    rm_r(prefix/"etc")
    pkgetc.install doc/"i2pd.conf", doc/"subscriptions.txt", doc/"tunnels.conf"

    (var/"lib/i2pd").mkpath
    (var/"log/i2pd").mkpath
  end

  post_install_steps do
    # Create symlinks to certificates and configs
    symlink "{{pkgshare}}/certificates",    "{{var}}/lib/i2pd/certificates",      overwrite: true
    symlink "{{pkgetc}}/i2pd.conf",         "{{var}}/lib/i2pd/i2pd.conf",         overwrite: true
    symlink "{{pkgetc}}/subscriptions.txt", "{{var}}/lib/i2pd/subscriptions.txt", overwrite: true
    symlink "{{pkgetc}}/tunnels.conf",      "{{var}}/lib/i2pd/tunnels.conf",      overwrite: true
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