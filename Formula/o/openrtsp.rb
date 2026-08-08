class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.08.07.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.08.07.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.08.07.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "f215e4acee8dc8a1b583073e17de02bf2b05542368f918d8e72c4ae8a00d3e03"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "235f6aa8361e0dce650e5c10c1fee970b17cc26e707ffc0da367b5d96366fc51"
    sha256 cellar: :any, arm64_sequoia: "3585e7fe7decd4d7e783ad15f027fafdd8e3003831511f296ba11bc55803d721"
    sha256 cellar: :any, arm64_sonoma:  "6c14e79fa7c0062829f5311bd6482a0b967dd41cba018e568390f272c249221a"
    sha256 cellar: :any, sonoma:        "08bca181204e9a60ddaf56ee0e375b1bfbf12fee9d9352f5f0caae275ad719b7"
    sha256 cellar: :any, arm64_linux:   "9f8e9eccd6eb4c86b079613aa83446fe97bb70cc6e94465a0a50875b8b2bd02f"
    sha256 cellar: :any, x86_64_linux:  "e1a306adc836c8ae61d8878aa9f2e182f03b2b00e56d578bc0f658ccb457f4bb"
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