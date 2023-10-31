class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2023.10.30.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2023.10.30.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "f51e5f2d6ae01bc09616b5dc39464e28b2adfb3832f46fa2a0b021c5ab4ec0eb"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "956a3f810c46818f940f21649f5d5d5f516b48d0d38f6f35c6b4157d22b82fa7"
    sha256 cellar: :any,                 arm64_ventura:  "7106040aff141c2b166da1be51a1ba606d9f5732f4d4bcc7e903b6508c9ea134"
    sha256 cellar: :any,                 arm64_monterey: "3fb7eed1806c2de7d499e77979a0716177d96f5048450cab7eda6d16d4b11a07"
    sha256 cellar: :any,                 sonoma:         "c407165f8fdcf041818ce371edf08099d05f1ed968da7deab80dfe8cb0875e3b"
    sha256 cellar: :any,                 ventura:        "4e01ed81e15cc9189b5273fef36a2b795a780a22b6569bad95654c43829908fb"
    sha256 cellar: :any,                 monterey:       "1dddcb7f1f88cb0abeff7f71eb3ce94aedfebc66d3623391e9a2f7d99d41854a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93d5b58ec3e88ad9e2a0f3977980f7ab97189d517015fcbfccdfe9c118f49a03"
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