class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.08.25.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.08.25.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.08.25.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "5f3d151358117c7a400c61ae026032a46f140fbe1a80a12da31ef025f7c6e93d"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f8c4c5f4b10550a87af3cd1a64c11e74d72d65c509c6cc14d25b174e3a657db9"
    sha256 cellar: :any, arm64_sequoia: "43e521b5106c96afed8ee1c15b8e74bcef0164ec6c66ed814db91d3080e1664f"
    sha256 cellar: :any, arm64_sonoma:  "74ab4e6c462c30db74d5998053eb0393291377fdc1d873f4a81e8892d9a9b5d5"
    sha256 cellar: :any, sonoma:        "f2a417b93060209e5a2a556d69939bb251b8e61d67fc316003df58474d789f2e"
    sha256 cellar: :any, arm64_linux:   "a6179c5ec234485fd02d1be3db091b4b8870a0af6c6915f2a0c24dce5d984192"
    sha256 cellar: :any, x86_64_linux:  "0b0ca394be8c2b373a993c48329022c30d09379c637abc21b7393f5ce9d4e62b"
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