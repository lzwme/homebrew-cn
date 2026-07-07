class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.07.06.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.07.06.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.07.06.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "1f2cfd356a4baf6539bd76110b67e5058fd99d44ee983d6fff73e4756ecf817e"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2f554dd1d7e27d2f03f4e323165b46fcc75dfac9f6885b9beeafc9f70a1839e9"
    sha256 cellar: :any, arm64_sequoia: "0b58d3816154cce87d312796b26e37f9f7e6c84bfce1b5d0297cd85c95fe58fa"
    sha256 cellar: :any, arm64_sonoma:  "3c9b710ee7730fbe45df5b8260b2d61114bbca4cdec4a950bb623b4acda00358"
    sha256 cellar: :any, sonoma:        "b9b9ff924dbf6b4800ed24234840411d05ac30a13a36473e1a84e0e95fc2f780"
    sha256 cellar: :any, arm64_linux:   "2797a1f54e4a7a01efef692cb584504b2024b162425a09a7135e7120a8e98e11"
    sha256 cellar: :any, x86_64_linux:  "d930bb68a83ab95905a5bc9d18d9c46011bdd588b96ddaf2c1295e9810d28ade"
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