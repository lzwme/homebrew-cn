class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http:www.live555.comopenRTSP"
  url "http:www.live555.comliveMediapubliclive.2024.10.31.tar.gz"
  mirror "https:download.videolan.orgpubvideolantestingcontriblive555live.2024.10.31.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "75a4568a0a979326674ca45dfd1dfaba9d916380e80cc46af7792ed740595774"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http:www.live555.comliveMediapublic"
    regex(href=.*?live[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a2b15599aa39fdca14be8f0aa1565751b057f6d5e3be41871b795e2aa9f4fa1b"
    sha256 cellar: :any,                 arm64_sonoma:  "a6af3983d0dc42e8586c365c553b5a1374c3601496784c5dec10fc539522ab49"
    sha256 cellar: :any,                 arm64_ventura: "4edce7e27e4cac73b3ff1dc4388c1fa422912f0f2ed4ec0e886fecd836196496"
    sha256 cellar: :any,                 sonoma:        "6462765a5168afc47e49dc0f8d24d89310bd13ed3e47c9d5db55c7c19c6854a6"
    sha256 cellar: :any,                 ventura:       "58ddd93f4de181046c7a658c42cf68be96cd4cba449026b9cd0022d395452e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f671fa634ac73182f87ecaee99a81da5e9d4af795a4d0fde6c0a26b32c969ed"
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