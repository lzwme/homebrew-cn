class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http:www.live555.comopenRTSP"
  url "http:www.live555.comliveMediapubliclive.2024.10.10.tar.gz"
  mirror "https:download.videolan.orgpubvideolantestingcontriblive555live.2024.10.10.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "b718d2de936648d3e6fc84702056e7e0aa9609f9cfaa0606312733e9eb4b45c1"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http:www.live555.comliveMediapublic"
    regex(href=.*?live[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f456665b0418292622bcecf2e6a255d9e673cb64b70c7065bf4363ed0fafaef9"
    sha256 cellar: :any,                 arm64_sonoma:  "fce942b7b09ce8153a9c185b23cb708ea082de607740948a5d57dd8e663e82f0"
    sha256 cellar: :any,                 arm64_ventura: "ed0df1cc4d92faa0a8a9d64c0a7eb7993e5fd1e993b04d2cc45c3018d19dd61f"
    sha256 cellar: :any,                 sonoma:        "2415ecd3f9b0cb95990b85fc1ad514bc10a74acb443e68c807222f07781406bd"
    sha256 cellar: :any,                 ventura:       "3fde2606592a080f3a5051055a032d15b2c63deefcbb4cd5bbe5336ffd1a3cdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f477d7ab35060420447732b3510eafbca8d2166aa82edb26f049b1a51019151"
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