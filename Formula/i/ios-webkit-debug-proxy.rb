class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://ghfast.top/https://github.com/google/ios-webkit-debug-proxy/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "768f101612bf5d2507957f10a8e34e98675ea8fe3c63b8ed78772f8abd103fbf"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/google/ios-webkit-debug-proxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "495426409dc5f5d8f3a8308e7595d5c093d054b2e7565a3c431b03b3223559f3"
    sha256 cellar: :any, arm64_tahoe:       "27e1a82b10af5bb64bd1d70d21c4c49c9eac1f99c91b1cc5f2fdd932518067ff"
    sha256 cellar: :any, arm64_sequoia:     "10cc141b7758f40c458df84a0e68496b140e4bce7b165e0db08af281fc819b9d"
    sha256 cellar: :any, arm64_linux:       "7049de87834c2e981822f6fc2754440b96cb576a13c37b72d2aab0b30ecdad39"
    sha256 cellar: :any, x86_64_linux:      "0f4fd6abf575ee83539ef31c76e6f0c3f54a2d9d525b0fedf3ce68e351233932"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libimobiledevice"
  depends_on "libplist"
  depends_on "libusbmuxd"
  depends_on "openssl@3"

  allow_network_access! :test

  def install
    system "./autogen.sh", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ios_webkit_debug_proxy --version")

    base_port = free_port
    (testpath/"config.csv").write <<~CSV
      null:#{base_port},:#{base_port + 1}-#{base_port + 101}
    CSV

    output_log = testpath/"output.log"
    pid = spawn "#{bin}/ios_webkit_debug_proxy", "-c", testpath/"config.csv", [:out, :err] => output_log.to_s
    sleep 2
    # Setup fails in both macOS sandbox and Linux where we don't have usbmuxd daemon
    assert_match "No device found, is it plugged in?", output_log.read
  ensure
    if pid
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end