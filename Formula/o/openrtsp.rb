class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http:www.live555.comopenRTSP"
  url "http:www.live555.comliveMediapubliclive.2024.06.26.tar.gz"
  mirror "https:download.videolan.orgpubvideolantestingcontriblive555live.2024.06.26.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "97e9fa015fc6559808955ec7a0c90fe4000b868f04c58794ff627f8a562d2f1c"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http:www.live555.comliveMediapublic"
    regex(href=.*?live[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4e40bb28dc6d75fef8c033d5637051ad30ff5df2ecaf12c964e66daa651472d2"
    sha256 cellar: :any,                 arm64_ventura:  "cac9b2d36f17c746f0ea5620b5e37ef098f09a629824454fa8abdc35cd4a1296"
    sha256 cellar: :any,                 arm64_monterey: "511b1364f386ffbfec083292dc5f33fcbbb594c5b632bf9d1daef05ec3370aa5"
    sha256 cellar: :any,                 sonoma:         "a7b954487074b4c72297571c542167e3d04046f73deeeee1181e13de00b657e0"
    sha256 cellar: :any,                 ventura:        "a18e2876ced516a0316a19375965fad136267b8b5fd8d36494209561993e3382"
    sha256 cellar: :any,                 monterey:       "a922aed761e527bb7bcf51190d4195e3eceb1405516ec4f2ae3e3494cb3ceea0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "038ad248ab32e2781249ab82d1827207585a9fdfc8aafdc4e9022c432ffdd824"
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