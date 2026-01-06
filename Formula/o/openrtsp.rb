class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2025.12.26.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2025.12.26.tar.gz"
  mirror "http://www.live555.com/liveMedia/public/live.2025.12.26.tar.gz"
  sha256 "9cb04dc576ff80dd363c9f98c421297e8ab50286ba80acc3a2ca94495e5b883a"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "20fd58449f6e6da93e9e91a6190b0492364ead2206acb92f9a7e532103a7c693"
    sha256 cellar: :any,                 arm64_sequoia: "bcb754751bf1270fe7254725fcca37ede03a4749e294f644bc2578d1bb32a2da"
    sha256 cellar: :any,                 arm64_sonoma:  "2ea41633070087ff52dcfd5326a8c5ac4b08e822399ad935e4fb3bc475e485b3"
    sha256 cellar: :any,                 sonoma:        "d130ecfe9e386b60130272be4db22394d68d211c60ca3cc2ede1e11a6ea09474"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "774049ae99c0cac6e390de6d82aff278160782d4cc0e126b8a5dd59938cd211f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d6d55b9eb6afd0944fbce467bbd55d9a4a529b3be522bf5128d6365305dd103"
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