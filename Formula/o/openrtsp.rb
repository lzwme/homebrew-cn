class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2025.09.16.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2025.09.16.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "31e44f177cc85c9419512f6500b9328ce24a3fda880cce369edacac55a439313"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6759534538a82510e592a5f2d9161fc760cf6266a98108029fba9f7832bac866"
    sha256 cellar: :any,                 arm64_sequoia: "93209c1646770bda79db5061be1b08aa6bf4ac92f531d09f2b3b1656100b5454"
    sha256 cellar: :any,                 arm64_sonoma:  "320a8f65787033f064fae965affce18cafb7bac44f61af3b21a2fbc3ab361027"
    sha256 cellar: :any,                 sonoma:        "5ac706c02f363d2f01e88317797d80c54c1a7f8452d97276ba1219a94468cb56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "057426908d1be9a1a4586f5c6b9454edf1ad702e75a06aede9f833e0c1a4639c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c00a66b04b6f035f7b8cbefbbdf52a79a70e5644c7cc063da7e77326b5ec61f0"
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