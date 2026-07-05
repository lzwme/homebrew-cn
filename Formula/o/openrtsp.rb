class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.07.04.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.07.04.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.07.04.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "b89b425ec6fedaa4dc0b478ba9146a431b265f5352cb17fc44c14402c512e378"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ca582a35c3bbfdbddf0569844a1f8d8eda3b863170eb7f846a5cefe985d5e550"
    sha256 cellar: :any, arm64_sequoia: "2d960dac1d162ea2a919708d05b9517e14d84c52f9c8a1605a007d425c98dd61"
    sha256 cellar: :any, arm64_sonoma:  "197a0e030b2f4de5145eb2e7ad5ac7564e044c55d8f86a3979fb9ea1dff79654"
    sha256 cellar: :any, sonoma:        "5252e7ef9a5bd6d6497de378c521f5e0948b9d20470468e3144a8f401269f1d0"
    sha256 cellar: :any, arm64_linux:   "e29a6445a4392f09d34d8b5fd00fc45ebbb6825331e14ef30c3427abbde33cf4"
    sha256 cellar: :any, x86_64_linux:  "c41274c79f126466eb69003c921c5738e1c49b563d36dc039f1049582d88822b"
  end

  depends_on "openssl@3"

  def install
    # "test" was added to std::atomic_flag in C++20
    # See https://github.com/rgaufman/live555/issues/45
    ENV.append "CXXFLAGS", "-std=c++20"

    # Avoid linkage to system OpenSSL
    libs = [
      formula_opt_lib("openssl@3")/shared_library("libcrypto"),
      formula_opt_lib("openssl@3")/shared_library("libssl"),
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