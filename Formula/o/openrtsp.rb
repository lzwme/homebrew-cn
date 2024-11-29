class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http:www.live555.comopenRTSP"
  url "http:www.live555.comliveMediapubliclive.2024.11.28.tar.gz"
  mirror "https:download.videolan.orgpubvideolantestingcontriblive555live.2024.11.28.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "a9af16f46d2f4c7ccdbfc4b617480503d27cccb46fa5abb7dfd8a25951b44cc3"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http:www.live555.comliveMediapublic"
    regex(href=.*?live[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3a859bd9b797cce39087006bc8e01a96a92afed7a6c279b239952f25cbcf8bc6"
    sha256 cellar: :any,                 arm64_sonoma:  "5ca1cbdd328cbec584beff0277595163bd2e00f111c0643be7201791d064d3b0"
    sha256 cellar: :any,                 arm64_ventura: "c335d6c45f980f8608cad7c04a5f8f986c5fc82b1e89ed2b326369233e504328"
    sha256 cellar: :any,                 sonoma:        "81e9f9c1698f63b74664200da0e99a33b919351a73235533ab4e29c275139629"
    sha256 cellar: :any,                 ventura:       "21525f0ae719555f96b00e31709e29aedab838d6a4925e611a6e34b83deda2cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4688ba0329d11cfaff6ec8dcabc953bf4bba943e295f58748bdad3a16fec577b"
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