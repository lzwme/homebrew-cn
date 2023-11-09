class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2023.11.08.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2023.11.08.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "7ab447ce71e151a1042c37f8aec8d0ac6becf486670241b3e64ae7c520e49486"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "378b53d8b1800c25146aa1f646501757a3ada3310b0387af7394185c9c5b7866"
    sha256 cellar: :any,                 arm64_ventura:  "9118152f827d6d31467b93b669546d38a4084e6d8b03a291bb25fbd4de86bf2e"
    sha256 cellar: :any,                 arm64_monterey: "4754b78ad6ae1da43455b55f0bc16499ddc8bd24307b4e280f05f9bd57a32cff"
    sha256 cellar: :any,                 sonoma:         "c4004f4b9976377f40b0549766da8baeb6107f6c42c783ab3e5879804547ea59"
    sha256 cellar: :any,                 ventura:        "8facacb7e1de4dd7bedae1cb654f81e1f421044825c1e3f042ad27a4685082a3"
    sha256 cellar: :any,                 monterey:       "8e871b4f9634b80a3d296bada4395ebfb548b352495728082e8ae16c140dc2c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d51835e1ff76604ddf06937a8b26c52bac7a7c7d1823582a700c43b3ab7185bd"
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