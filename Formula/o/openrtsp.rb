class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.05.28.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.05.28.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.05.28.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "9ea78251faa3ffb6d7e82f2e7979b8bc422a624cc0562bf0ea2a52990c3ee88d"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "757bf1cd172ed7a96ec67f013fcc6db4f3b8ad62d8563754e8c79b6dc53f1fb0"
    sha256 cellar: :any,                 arm64_sequoia: "68202312a8e69186912588c1a80a97c6461f3b47b90dbfc43bbd28f3756cc3a9"
    sha256 cellar: :any,                 arm64_sonoma:  "45401a15157a13a46803e26a4b12de3cb9034ed4c7ad904125954f957eefea60"
    sha256 cellar: :any,                 sonoma:        "205d7f0c0eeff55742a038e73d8f0b52a8d975a695594d6ea84a46fe8f4779fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80b1f211e82efa43ee72c436d45ffb8ed606b65f8d70706edc98f2162eacf2d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3527858268f299c16e471bc2113c8aa4abe6824b87657146160a958e5c8dc2f5"
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