class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2023.06.20.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2023.06.20.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "4d797e6a5f8cfd57051cd58072b9bc9f6657dea3f1ce26e901efb874d3391bba"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "18055e572369ca42ccf4592bd3b524f43967f696a233812e20d2f5b0c9f66408"
    sha256 cellar: :any,                 arm64_monterey: "0e9fa6cb13999055f2bc84c6360b2339b7b44cd75111600108a3005a586a10fe"
    sha256 cellar: :any,                 arm64_big_sur:  "cad33fc168b28f49adcfcdaf47848a7ebf959d3ec10a8b0b9957ef4eb9c0afaa"
    sha256 cellar: :any,                 ventura:        "886c7f1d38480d25d8f830c226e44291f8f912d8add511c03321499c3c2f5cda"
    sha256 cellar: :any,                 monterey:       "d2450048bc5325ce4fa35666d6b5774828156a9dd867c84d8a55970c34142e10"
    sha256 cellar: :any,                 big_sur:        "67042ea57bb50ade5a92f92c0f364ccd405bda6cd6876fe6194eee41ef46b8e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb94e9fc1187461062232f763bbf600e48aa9c6fb95b3431050764ae4df2d1ee"
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