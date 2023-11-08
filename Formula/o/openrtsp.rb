class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2023.11.07.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2023.11.07.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "8ddd5ca51440a9c9ab1d906e17a7ae03760fb54d3cc9909dcffb267d2bcef911"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e5f90b8ee4e456c22e8f41e17f49bc9790e500141bcb3014894f36804865c08b"
    sha256 cellar: :any,                 arm64_ventura:  "bd719c807361deeda5c96f3bf2eef667c8bc0b8a47cf734133c893da737675d4"
    sha256 cellar: :any,                 arm64_monterey: "b2b3c1c0f5b7ced29285de263f244dc7a14cce22bf03baa4cbff578675313159"
    sha256 cellar: :any,                 sonoma:         "ef58606695da3cecbbf7213a194e230aa491b088deb5949844a8dd90760b222b"
    sha256 cellar: :any,                 ventura:        "717b9abea7784067435363367b339ceec1a856165b24d1cfbc636d75c4641c15"
    sha256 cellar: :any,                 monterey:       "7d654d021ccee7edee5e670525662c6cb642df5647d4025bdf27d906330dfb8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d41fdd4325c023dae50144005b37c6fa0727cca719416d3ab12d78fa3a7aeaa2"
  end

  depends_on "openssl@3"

  # Support CXXFLAGS when building on macOS
  # PR ref: https://github.com/rgaufman/live555/pull/46
  # TODO: Remove once changes land in a release
  patch do
    url "https://github.com/rgaufman/live555/commit/16701af5486bb3a2d25a28edaab07789c8a9ce57.patch?full_index=1"
    sha256 "2d98a782081028fe3b7daf6b2db19e99c46f0cadab2421745de907146a3595cb"
  end

  def install
    # "test" was added to std::atomic_flag in C++20
    # See https://github.com/rgaufman/live555/issues/45
    ENV.append "CXXFLAGS", "-std=c++20"

    # Avoid linkage to system OpenSSL
    libs = [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
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