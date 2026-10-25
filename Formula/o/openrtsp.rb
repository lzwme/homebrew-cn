class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.10.24.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.10.24.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.10.24.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "5d6244604b364251d0c0b0fc87a849488958802245b1473eaaf55eaaef5a838b"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "399b955d831813ae8cfcbdf65276a63a8dec5d9255759ee9d712fda1d45f0d17"
    sha256 cellar: :any, arm64_tahoe:       "208de763aebfb5dad8cf9b334f1a8e79eaea21dfd85884f8fcd5f8d6ebe31f03"
    sha256 cellar: :any, arm64_sequoia:     "705f646a11bc379d70ae159b839e7436a91f3610be79203cd7fefd2915643507"
    sha256 cellar: :any, arm64_linux:       "17f15a73f8b4a203b487874c7404f2cbfcab66dec2f32ab002c4add3bd300c08"
    sha256 cellar: :any, x86_64_linux:      "7bfef47e959598318ae2d2279594ed9529b61b9309002f4417ce7a9f0159ea25"
  end

  depends_on "openssl@4"

  deny_network_access!

  def install
    # "test" was added to std::atomic_flag in C++20
    # See https://github.com/rgaufman/live555/issues/45
    ENV.append "CXXFLAGS", "-std=c++20"

    # Avoid linkage to system OpenSSL
    libs = [
      formula_opt_lib("openssl@4")/shared_library("libcrypto"),
      formula_opt_lib("openssl@4")/shared_library("libssl"),
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