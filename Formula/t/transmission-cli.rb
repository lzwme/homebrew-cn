class TransmissionCli < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://transmissionbt.com/"
  url "https://ghfast.top/https://github.com/transmission/transmission/releases/download/4.1.3/transmission-4.1.3.tar.xz"
  sha256 "ce7d2d8b101f7eb54bc3cf0bc55f52f7ebd4a25fa48e00bdca9a7e0fc02617da"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "e37ca28b0a7f92964f29138c627f89fcfaf7cbcdd476dac9a93487fdb682c3a1"
    sha256 arm64_tahoe:       "6d61551707802dcfd5982c6fb4813a9ded2e9b3c36864013acb992f44216c94d"
    sha256 arm64_sequoia:     "5811811858a492bd69597c1fa28a3c07013f32be2f0fa8f25282976a1299c407"
    sha256 arm64_linux:       "741d0fa868aa2345c4ce14887a3b1c646be81aa6b11d24445ae7569103abf14d"
    sha256 x86_64_linux:      "e2588c56a4fa9b6343e31af2437e35c86ecff55cbf1f697c539c94d2b4b6cc87"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "libpsl"
  depends_on "miniupnpc"

  uses_from_macos "python" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "openssl@4" # Uses CommonCrypto on macOS
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = %w[
      -DENABLE_CLI=ON
      -DENABLE_DAEMON=ON
      -DENABLE_GTK=OFF
      -DENABLE_MAC=OFF
      -DENABLE_NLS=OFF
      -DENABLE_QT=OFF
      -DENABLE_TESTS=OFF
      -DENABLE_UTILS=ON
      -DENABLE_WEB=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (var/"transmission").mkpath
  end

  def caveats
    <<~EOS
      This formula only installs the command line utilities.

      Transmission.app can be downloaded directly from the website:
        https://www.transmissionbt.com/

      Alternatively, install with Homebrew Cask:
        brew install --cask transmission
    EOS
  end

  service do
    run [opt_bin/"transmission-daemon", "--foreground", "--config-dir", var/"transmission/", "--log-info",
         "--logfile", var/"transmission/transmission-daemon.log"]
    keep_alive true
  end

  test do
    system bin/"transmission-create", "-o", testpath/"test.mp3.torrent", test_fixtures("test.mp3")
    assert_match(/^magnet:/, shell_output("#{bin}/transmission-show -m #{testpath}/test.mp3.torrent"))
  end
end