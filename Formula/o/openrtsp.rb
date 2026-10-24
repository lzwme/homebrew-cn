class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.10.23.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.10.23.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.10.23.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "edb5cc03ab575127d1ac880d12171da8188fad795cfc2fa7767917975a3785af"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ba64e946abc137af13ee8804469d6387d1fabb8a5d5796a98b83a345fe2e5ae9"
    sha256 cellar: :any, arm64_tahoe:       "f43d646f65a58b094ac9eea9389fda9d33b7f1c01a3668af139fdb8e6c79e196"
    sha256 cellar: :any, arm64_sequoia:     "1c48fc3276a8ab3c9f2841226aee5a0cd8098b6adb7a012c18d3b2cbccc9e63d"
    sha256 cellar: :any, arm64_linux:       "945fe313ec1bbade0536d47084f2c12a32697a22684a7f8f42e3757320b5a4fd"
    sha256 cellar: :any, x86_64_linux:      "af49de6584010fdc6494b3b13a07d4989a126bb7155ebfca16e5bdeb82948728"
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