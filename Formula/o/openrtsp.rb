class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.09.23.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.09.23.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.09.23.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "22da8a0e12219f049051052317ff3774eaae888e6f94fd7be746bc236ad0d7eb"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "8233da38c6d55a151733c9848910ed2e7a943498476f650108375bdc10d480f8"
    sha256 cellar: :any, arm64_tahoe:       "a3b2f72c67651a5cb6150e6a6abe42a1710cdbc3e186edd8319d392e4ba369e8"
    sha256 cellar: :any, arm64_sequoia:     "4c39375d0f66cb9c8a760cb059d5a2ed37de1a050501badbf56937042ba04352"
    sha256 cellar: :any, arm64_linux:       "4e2a8ecb51e8e79cb2fc24f6f705129bfa37dbd765040d7532ad2fe62125b4ae"
    sha256 cellar: :any, x86_64_linux:      "6f2e5492d46a0a019b775582cb6145288e39a3fdaec5487ee424e67010af58ea"
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