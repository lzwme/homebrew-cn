class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.05.29.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.05.29.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.05.29.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "6cda576ba057ce51499bd89552cec3ad4cc56123d7c26045250fc23fb052d6b8"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0f471917591a2b3ff865a7528d5e0e1f9c7b58b93f0ad286868461520f710429"
    sha256 cellar: :any,                 arm64_sequoia: "6fbfba433061b2ae480f4b6cfca52fb92840bd330487e5a95f0db7d7f0bc54b8"
    sha256 cellar: :any,                 arm64_sonoma:  "500ff0a28d6ba623d7b9b430c5ac39a9a39a30175c95238f8741cea6507cebf3"
    sha256 cellar: :any,                 sonoma:        "3a3c9a6247cefe1bf4b099cce272899d640789a6f07110d60adf8b50d043ad33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89cc05f9c69a91c63f8e7ce3b6cc51500d43b569bd1ccebc82d024042792d2b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89213826a596adb65edf59c0de5aabd483ddf19f14cd73bb661082ca330f4864"
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