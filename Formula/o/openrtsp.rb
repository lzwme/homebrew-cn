class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http:www.live555.comopenRTSP"
  url "http:www.live555.comliveMediapubliclive.2024.10.24.tar.gz"
  mirror "https:download.videolan.orgpubvideolantestingcontriblive555live.2024.10.24.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "84d9ff6166a5b5cf7fdf2de4b0529c5b0ce9f30c924ade7ed8bc45bbb9ecd02a"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http:www.live555.comliveMediapublic"
    regex(href=.*?live[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "63207d9e73c144f9a57ab631ccead018a6ead089edc67aed88e08a80ca18b1ac"
    sha256 cellar: :any,                 arm64_sonoma:  "44ff85759f6613d3bc160c1ef357493a99d36cf583c8ebca82bfd8ed28cd2b85"
    sha256 cellar: :any,                 arm64_ventura: "2981d59a750dfc1b2b90890e2486c7ad2459d2849b394ff2b5b9d75d52fe97cd"
    sha256 cellar: :any,                 sonoma:        "92e203ebbbc5b47ae66dff008614d9702296a23a7bce90f7d317420d2e368fe0"
    sha256 cellar: :any,                 ventura:       "48df92e4648151b4cdbfa91840dd1559bb9ab90521b14d98dea91fad9a0e6c7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b49d09e33cbcf38755abe226897ecba0b92272294d904592ae5d53c9d7e6904"
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