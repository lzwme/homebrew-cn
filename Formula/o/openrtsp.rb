class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http:www.live555.comopenRTSP"
  url "http:www.live555.comliveMediapubliclive.2023.11.30.tar.gz"
  mirror "https:download.videolan.orgpubvideolantestingcontriblive555live.2023.11.30.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "c6e7bef58b5d00cd97933018e9d5363d9de7e9bbcfc2550b207a81a9cf30b925"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http:www.live555.comliveMediapublic"
    regex(href=.*?live[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cae00d6f09657004d421b076ff5849182180d5dd97c9ae62ff84145317bd7f97"
    sha256 cellar: :any,                 arm64_ventura:  "ec7643055728df0ce9a1b9d42a95f9e930e2e5d1347dc3c4b5d66d0fe6c900ea"
    sha256 cellar: :any,                 arm64_monterey: "59a0629af7eca685c5bd9229024c8eca9df3218f92ab7286cef1f5955ffa8a83"
    sha256 cellar: :any,                 sonoma:         "10e98b053e99e35d7e6874c3a470201c5d448c624dff63a64f8cd3ccc840bcd7"
    sha256 cellar: :any,                 ventura:        "096765918410128144c3348558ecf8870660b6a71e7b1394dc6e26dd80a4387f"
    sha256 cellar: :any,                 monterey:       "70e21f3eca0d51d9d0d7fe946633f8de9b228cfd47776d15fd29f1a442881c60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a5ce236d3c6426d56ccec706b5bc122c3d4170898631850b8355b9f8d08a1fe"
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