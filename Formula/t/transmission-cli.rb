class TransmissionCli < Formula
  desc "Lightweight BitTorrent client"
  homepage "https://transmissionbt.com/"
  url "https://ghfast.top/https://github.com/transmission/transmission/releases/download/4.1.0/transmission-4.1.0.tar.xz"
  sha256 "dcd28c1c9e6126229c4c17dbc9e95c9fd4aed7e76f4a1f2a74604c8cddec49d6"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "9b87e790d245612dd2e8fd0ad870a9f0cbfa584638672cb9a2377e28a36dc88f"
    sha256 arm64_sequoia: "3f71576bc3030780b5d28040ab385a2c8fb102c9bba02e77f589c4dce479e615"
    sha256 arm64_sonoma:  "e879fc4ce079fc174720583304f728b8df1c42d6da274cc2a8d7fb00ce5857ad"
    sha256 sonoma:        "7606941314d87058ccad12e8fc382ac578b8eb6107a28531d83ebda92a60077f"
    sha256 arm64_linux:   "8a4f3e96438557d4e7481a63707957ce6e0e54d24b5587460fec310a899a8b89"
    sha256 x86_64_linux:  "df9b4532ad338a71d2a1e59926103fa02c1a35911da8f138848a80c8aa7fc421"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "miniupnpc"

  uses_from_macos "python" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3" # Uses CommonCrypto on macOS
  end

  def install
    args = %w[
      -DENABLE_CLI=ON
      -DENABLE_DAEMON=ON
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