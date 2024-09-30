class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http:www.live555.comopenRTSP"
  url "http:www.live555.comliveMediapubliclive.2024.09.29.tar.gz"
  mirror "https:download.videolan.orgpubvideolantestingcontriblive555live.2024.09.29.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "b572be3b3a9a32c790fe7a544d6509a5861fbe3eadc89351843ef4544d4274fa"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http:www.live555.comliveMediapublic"
    regex(href=.*?live[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "17eed7a5c8a47a7580f1d0797434212c6988e1d0f0e5b6954a32d3903dc9bd02"
    sha256 cellar: :any,                 arm64_sonoma:  "1beaea2c855ebb7739bc07a604339ad774cca3e77f54a8c8f79d475d283a9dad"
    sha256 cellar: :any,                 arm64_ventura: "d9ce53c207980402f2b2eb145f64ce82957e1ef1b19fc31578aefdfc5de52c76"
    sha256 cellar: :any,                 sonoma:        "9784a83e2f44f9b329546ad77ff257ea234b223b02fff3c39cda8266e879bce2"
    sha256 cellar: :any,                 ventura:       "7e2011024de54b53f656eb235008809a826dc122a19280447758b54fee6f0677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bca146bf1a401ca4c05d1b37713e3ad6196aa3062dcb62a405c726d3cb0c92c5"
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