class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http:www.live555.comopenRTSP"
  url "http:www.live555.comliveMediapubliclive.2024.10.29.tar.gz"
  mirror "https:download.videolan.orgpubvideolantestingcontriblive555live.2024.10.29.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "551ba52f7056251758c554db1248cddb73e193983f1af07faaabdeb629f40db1"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http:www.live555.comliveMediapublic"
    regex(href=.*?live[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f880854db6482cfbe7bfc8696552764d566238c1cd91209bad89284d797dab0b"
    sha256 cellar: :any,                 arm64_sonoma:  "8b6cee391cdb2a5213e6956a20e833356fd043061d9886c62a89e86f9c8005fe"
    sha256 cellar: :any,                 arm64_ventura: "144962eec871d997aaea6537165a3691beea038ac920983eff7b2d3834735081"
    sha256 cellar: :any,                 sonoma:        "4f341df8226f801dcf1e30ea9676192f4bb8a488f1c544a456d5927251109163"
    sha256 cellar: :any,                 ventura:       "184389b1f729a947eef862cad1c04e494c39c5daf9ba26844065d60023a81298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12d4302a28ad3bf6f33df969aec28ad7491463fc6c0ad0a777d43b29b1028125"
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