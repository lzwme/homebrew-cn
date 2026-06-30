class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.06.29.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.06.29.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.06.29.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "f8f9f56968e160b2864db5afcd95dc719205df71237fec63a3ff883b1d34ca78"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "32ebffcca9f656f37501c84b6785b79a4f74f0a96cbce36ff7a3ed0b57f0b7b5"
    sha256 cellar: :any, arm64_sequoia: "71d246f6f5502efcbed618b17961caf4521166bd9c44cb358851f9c743b04fa0"
    sha256 cellar: :any, arm64_sonoma:  "435d1acc07dfd620e6b9284ae6aa21dc3675bc6e6b450a73aad2136b66e98cf6"
    sha256 cellar: :any, sonoma:        "368529cdfb504acbaf62ab59f19d2159beb7ecf1da5ebbe50b5e312d8476bc92"
    sha256 cellar: :any, arm64_linux:   "d990d7d6e8e8a4f311c64f6977c050574f0b56e1b4036fc4bc8a0fdf6442647b"
    sha256 cellar: :any, x86_64_linux:  "340b996e6b32e04e327b77eb62b40f8f98befea82c4bbb9200186158a1913178"
  end

  depends_on "openssl@3"

  def install
    # "test" was added to std::atomic_flag in C++20
    # See https://github.com/rgaufman/live555/issues/45
    ENV.append "CXXFLAGS", "-std=c++20"

    # Avoid linkage to system OpenSSL
    libs = [
      formula_opt_lib("openssl@3")/shared_library("libcrypto"),
      formula_opt_lib("openssl@3")/shared_library("libssl"),
    ]

    os_flag = OS.mac? ? "macosx-bigsur" : "linux"
    system "./genMakefiles", os_flag
    system "make", "PREFIX=#{prefix}",
           "LIBS_FOR_CONSOLE_APPLICATION=#{libs.join(" ")}", "install"

    # Move the testing executables out of the main PATH
    libexec.install Dir.glob(bin/"test*")
  end

  def caveats
    <<~EOS
      Testing executables have been placed in:
        #{libexec}
    EOS
  end

  test do
    assert_match "GNU", shell_output("#{bin}/live555ProxyServer 2>&1", 1)
  end
end