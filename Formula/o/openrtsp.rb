class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.05.30.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.05.30.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.05.30.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "6e0948920ff8e8a7b76519c526efdcd51493862fbad2a1b6becdf2071d43d5f7"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "91a825c6c0e441ee4403d9fecd303e46a991a91e09b21d1be4a6273a9e421a1c"
    sha256 cellar: :any, arm64_sequoia: "cac0f55a8c415ed4fd7a3d58cda88e3df99af5f3109907c8bbd52f7366307af8"
    sha256 cellar: :any, arm64_sonoma:  "0549429da73f9e235d1495e45c34cfc789ab17448c108b5a78a28471b1d16b8b"
    sha256 cellar: :any, sonoma:        "59b677aae7b64b9480bc718bf3f62fcd080d529906e26c9022044a0a61454062"
    sha256 cellar: :any, arm64_linux:   "905a2598587466051c434a1dd41177a81b0e72c39940b4314026124d0112266f"
    sha256 cellar: :any, x86_64_linux:  "c5feb1ddc1a7426413b88a66f0eb275de39474caf94199688facdc170505ee45"
  end

  depends_on "openssl@3"

  # Support CXXFLAGS when building on macOS
  # PR ref: https://github.com/rgaufman/live555/pull/46
  # TODO: Remove once changes land in a release
  patch do
    url "https://github.com/rgaufman/live555/commit/16701af5486bb3a2d25a28edaab07789c8a9ce57.patch?full_index=1"
    sha256 "2d98a782081028fe3b7daf6b2db19e99c46f0cadab2421745de907146a3595cb"
  end

  def install
    # "test" was added to std::atomic_flag in C++20
    # See https://github.com/rgaufman/live555/issues/45
    ENV.append "CXXFLAGS", "-std=c++20"

    # Avoid linkage to system OpenSSL
    libs = [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]

    os_flag = OS.mac? ? "macosx-bigsur" : "linux"
    system "./genMakefiles", os_flag
    system "make", "PREFIX=#{prefix}",
           "LIBS_FOR_CONSOLE_APPLICATION=#{libs.join(" ")}", "install"

    # Move the testing executables out of the main PATH
    libexec.install Dir.glob(bin/"test*")
  end

  def caveats
    <<~EOS
      Testing executables have been placed in:
        #{libexec}
    EOS
  end

  test do
    assert_match "GNU", shell_output("#{bin}/live555ProxyServer 2>&1", 1)
  end
end