class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http:www.live555.comopenRTSP"
  url "http:www.live555.comliveMediapubliclive.2024.05.15.tar.gz"
  mirror "https:download.videolan.orgpubvideolantestingcontriblive555live.2024.05.15.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "32091fe578850441034d3c7e625575db0138ce998f3ea6943eff4a7042b7f03d"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http:www.live555.comliveMediapublic"
    regex(href=.*?live[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "df3ce1b5c75ddb1338fc9f0915de98c13b0ed0bbf7efe8c2f53a9b22466a97b9"
    sha256 cellar: :any,                 arm64_ventura:  "1ac910d91a8ab2284594a6bc08073e46a72b5a6eab48ad3b202ec5570b290edf"
    sha256 cellar: :any,                 arm64_monterey: "b86eb226a8909cc4e4c848a68ee0681aa55efd9571404bd845777edaac98e8e9"
    sha256 cellar: :any,                 sonoma:         "75bad1dfef04af505ec8081bee3e88362babcd4d360fb7f98633cafe2e5826b6"
    sha256 cellar: :any,                 ventura:        "9aa6b1f88c6404fc7d5a5ec7bb6363808aeca0d78236817dd1950daaea405066"
    sha256 cellar: :any,                 monterey:       "338eb7bf8d9add9d8956007ded138bbbfd52ec272f62c618296a52e02b15c656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64debeccae57bb1938a1f3335c536e3a8057f0f3655b9d2742929cda2a3dde5b"
  end

  depends_on "openssl@3"

  # Support CXXFLAGS when building on macOS
  # PR ref: https:github.comrgaufmanlive555pull46
  # TODO: Remove once changes land in a release
  patch do
    url "https:github.comrgaufmanlive555commit16701af5486bb3a2d25a28edaab07789c8a9ce57.patch?full_index=1"
    sha256 "2d98a782081028fe3b7daf6b2db19e99c46f0cadab2421745de907146a3595cb"
  end

  def install
    # "test" was added to std::atomic_flag in C++20
    # See https:github.comrgaufmanlive555issues45
    ENV.append "CXXFLAGS", "-std=c++20"

    # Avoid linkage to system OpenSSL
    libs = [
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
    ]

    os_flag = OS.mac? ? "macosx-bigsur" : "linux"
    system ".genMakefiles", os_flag
    system "make", "PREFIX=#{prefix}",
           "LIBS_FOR_CONSOLE_APPLICATION=#{libs.join(" ")}", "install"

    # Move the testing executables out of the main PATH
    libexec.install Dir.glob(bin"test*")
  end

  def caveats
    <<~EOS
      Testing executables have been placed in:
        #{libexec}
    EOS
  end

  test do
    assert_match "GNU", shell_output("#{bin}live555ProxyServer 2>&1", 1)
  end
end