class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http:www.live555.comopenRTSP"
  url "http:www.live555.comliveMediapubliclive.2024.09.24.tar.gz"
  mirror "https:download.videolan.orgpubvideolantestingcontriblive555live.2024.09.24.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "15249fe0ae4827c74d76460e66b357c8009541a1331ad858bfe94f592d6f7167"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http:www.live555.comliveMediapublic"
    regex(href=.*?live[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3c6d15de73ccd51fae5f5559343f38aa5ef5058ceb4fb8039ddc4aa8069b3654"
    sha256 cellar: :any,                 arm64_sonoma:  "f10170b806088927fb231e1107bd5d995b6bac0d9a3a11f094b38dd3047a40f1"
    sha256 cellar: :any,                 arm64_ventura: "4459f454e1b75566779bba443afdf132c5301aa7bbcea8b818258f7d0bf15780"
    sha256 cellar: :any,                 sonoma:        "c4ead8541995d2cc569a4e1d4fd05e552d9fc93f9ff4033e25966615b673b925"
    sha256 cellar: :any,                 ventura:       "c232ff6548bb67e2dc3c56b1fa5d80dd661fa42c28e4a14ed79e37a82d11d7a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76320434ad6a58ba68a4b7ca00a97cc66fdf45a8996cb889c018376f285997dc"
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