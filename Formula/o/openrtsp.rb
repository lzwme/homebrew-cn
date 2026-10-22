class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.10.22.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.10.22.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.10.22.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "248b3968bb095ad93fd592ee35f438748b0064a98bba3740a6467ff2a7f4bec3"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7dc76440ba1cc604c23a0cdb1e2ad99d60e3f59d61436e5a02c43b993bcef027"
    sha256 cellar: :any, arm64_tahoe:       "7fc92ce87365f96b2553c6b10460d02711636827cf5516fbb5a8c0c48a0f93db"
    sha256 cellar: :any, arm64_sequoia:     "bb7beeac7c1d9ea35101f3061c8c32017c980648066eadc1eb2e787d115e6bec"
    sha256 cellar: :any, arm64_linux:       "8de8cfe7f6f19dac9d835743f821039b8e4a754c34f76ae6b03e03390fe84c92"
    sha256 cellar: :any, x86_64_linux:      "f5a29dcfdd3f19168ff99ac9fbcec27049e075fc9e3ea18609325b83bc64ad4c"
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