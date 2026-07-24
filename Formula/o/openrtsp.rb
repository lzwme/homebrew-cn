class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.07.23.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.07.23.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.07.23.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "4b4bcdbdaa4a2b060ba9e193312bd0819dd134fc4aff01aff998d08ad6f2aeac"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "81d4a1d501176f91b005077f521458bfa9db45ae2664ef57f1909d07113e7e94"
    sha256 cellar: :any, arm64_sequoia: "ab09081ef366dcbb4e461ee81cde31a9d2555872622c4433358c1067f9644cab"
    sha256 cellar: :any, arm64_sonoma:  "962d8fefcf5d7c0d661204815973b3b4014cacfdff91eb1292ab288e7c8cd84d"
    sha256 cellar: :any, sonoma:        "3a82ca18e7f665d1d5fe2dec94d08fc8b2aa8c6cee36571447aaf85f18043ba1"
    sha256 cellar: :any, arm64_linux:   "ad9008df3dec9c3b91a796085e8efc048085d0b6fd79f97870222fa6935b192f"
    sha256 cellar: :any, x86_64_linux:  "068f9b07424e9a7a0a64a4faf825fd59051c95ab9976183ecd37cb92cd87834f"
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