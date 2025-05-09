class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http:www.live555.comopenRTSP"
  url "http:www.live555.comliveMediapubliclive.2025.05.08.tar.gz"
  mirror "https:download.videolan.orgpubvideolantestingcontriblive555live.2025.05.08.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "52f6ad40580c00693dbc382e0e7e2aabc1b1bb0d6dcf1fc45f7d491fdcd023ef"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http:www.live555.comliveMediapublic"
    regex(href=.*?live[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "29e06962412562175dad661c57cfe715af9925cebf0fab898b210e2fc73b6eda"
    sha256 cellar: :any,                 arm64_sonoma:  "758f7456a9c59e03fdc0a8cced0c283b50af553bf655eb13572e6eab4e3b3ad1"
    sha256 cellar: :any,                 arm64_ventura: "c010ca5fa02921b7ae923aa6bab43ddc92c41b06e237a3eb0da500de03bc3b20"
    sha256 cellar: :any,                 sonoma:        "dc73335a0fda284247ad1bdaccbfe9d9d0916a6d4cd2367720e58593175f09fa"
    sha256 cellar: :any,                 ventura:       "acc1be7d6dd5e2622ee37878577f6cc40d18bb5fe7408718ab0a0ebe35eb0fc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ab9222b7e1557cc44b2bb633dd191945424cb18ef0bf1cb18d3641a850614ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84bdec8d93e663e328a55db8b376c985dfc0130aaa547600a8ab9a9c4ca79af6"
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