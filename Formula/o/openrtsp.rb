class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.10.13.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.10.13.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.10.13.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "49576e41ec12be5db120bac1a665305d7c3ca62745249c48a6df0b3eea312670"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1d7885146bd99568dc7881d8f5ae3e106de15486dcc77decf3c31aba4b71aecc"
    sha256 cellar: :any, arm64_tahoe:       "fc76eb533b85d7eb50395f4d7e69430e9b0f5b4fae54b3bd09a5c1e7fc132271"
    sha256 cellar: :any, arm64_sequoia:     "fe0136d8bc44e8fcccfa74d3f60ceb4e8b742133ce2dd328d85dccb91bbf043f"
    sha256 cellar: :any, arm64_linux:       "f318286a88deda809a169b89c6579dc8c16b1874202a49f2d849ab171e13efb6"
    sha256 cellar: :any, x86_64_linux:      "1514a3d6052dac596cc533a86201852741493ca54a5fb7fc31126accc3ca7afa"
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