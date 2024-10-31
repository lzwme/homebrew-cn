class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http:www.live555.comopenRTSP"
  url "http:www.live555.comliveMediapubliclive.2024.10.30.tar.gz"
  mirror "https:download.videolan.orgpubvideolantestingcontriblive555live.2024.10.30.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "1d16fbf44b47b61203e8dce6e91449f024ccb48dd40a38d5f82800340c0961b5"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http:www.live555.comliveMediapublic"
    regex(href=.*?live[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a3bb6cb59da2f756400ebfd50ee91111356947b7ebfb2f83937dda947ab6ab11"
    sha256 cellar: :any,                 arm64_sonoma:  "d158f87cbc890b4165427eac4695d43843aed92e55b66a2293bf9ac859365c4a"
    sha256 cellar: :any,                 arm64_ventura: "822ae9b0ae404e9f16f0cbe44925d86d8e7505cf93bda040fe79a25153bff4c2"
    sha256 cellar: :any,                 sonoma:        "1ea5f413cffe2d4fd6c5e02971f7b41dbfef96bb2daabd137b7bd2e591810519"
    sha256 cellar: :any,                 ventura:       "299431cf6578450cea1afec244a05f444044659e6df6e82a151c2861b2ca9a65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b49c91de04eec292f0098f6b7b4ae55ee9e3806d082b11750055d25433bd22d"
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