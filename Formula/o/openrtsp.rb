class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http:www.live555.comopenRTSP"
  url "http:www.live555.comliveMediapubliclive.2024.09.25.tar.gz"
  mirror "https:download.videolan.orgpubvideolantestingcontriblive555live.2024.09.25.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "0b7e54a9982291d6ad7935276e86a0778d6cc0b5c61d8344de90db55d48e9495"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http:www.live555.comliveMediapublic"
    regex(href=.*?live[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "50e4d447f709bf9bb67d753a99f57800f68857f5f67313da4d935a40831b8082"
    sha256 cellar: :any,                 arm64_sonoma:  "7e3f3bffad64cbc2adc4df926a6404b21ac28309109fe72ffa3ed6a0978da0cd"
    sha256 cellar: :any,                 arm64_ventura: "12151bedd793ebbfc72bcf4ae2b3e8d6361571ee276da6999ed8cd87d23f25f9"
    sha256 cellar: :any,                 sonoma:        "8a368a4b30ef897c27f6a52091340f199a75a670aed241f2008ff01209160390"
    sha256 cellar: :any,                 ventura:       "c967f4bfb29e14e2fd31e0b76fc7cfea7da011284c3dd3e59d1d94cb37e42ec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69f8becb17a2f2460f6c5197fb1d8958724f806e1435772e735fcc542b96b9f6"
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