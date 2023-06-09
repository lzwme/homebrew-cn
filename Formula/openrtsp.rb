class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2023.06.08.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2023.06.08.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "db0485b1c3f8d62771db56be43c58f90708b19df9f2e7c30a534e83ad8b0c5bf"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b204dd2936ac4f0db85e2e10d5ed6f174aedf77157d377861f4df1c77e089905"
    sha256 cellar: :any,                 arm64_monterey: "6d860fb40727be4359828adbb59950bf9bc53c46da768a477cc3cda21f613e26"
    sha256 cellar: :any,                 arm64_big_sur:  "af66e9114276e22ae241aa79c0cc07fb1c2489cd641d472b15b7c35a977bf070"
    sha256 cellar: :any,                 ventura:        "2fe7af00fa83f97cc2a10bdec33a95f67893de3f7caa7d9d04f3dc2ac84045c6"
    sha256 cellar: :any,                 monterey:       "56a3ae3ce1b47468991c2c09315cb5ada7d6a67f230111ed8bdd0442f47db439"
    sha256 cellar: :any,                 big_sur:        "3547ac548dd5f416c7f88f4fdc320c618fe6fb534659073cf554efe7238be781"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c399adab322dc5a796d2349bc7d86f4ee7097728e29384a3c41a19dca274abc"
  end

  depends_on "openssl@3"

  # Fix usage of IN6ADDR_ANY_INIT macro (error: expected expression). See:
  # https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/netinet_in.h.html
  patch do
    url "https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/formula-patches/2eabc6f/openrtsp/openrtsp.2022.11.19.patch"
    sha256 "33f6b852b2673e59cce7dedb1e6d5461a23d352221236c5964de077d137120cd"
  end

  def install
    ENV.cxx11

    # Avoid linkage to system OpenSSL
    libs = [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]

    os_flag = OS.mac? ? "macosx-no-openssl" : "linux-no-openssl"
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