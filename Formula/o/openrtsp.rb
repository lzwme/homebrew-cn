class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "https://download.live555.com/live.2026.06.12.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2026.06.12.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/live.2026.06.12.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "ee0e1387747d5fea46f4652249e13020714635fff1f507917122df86b58bd1cd"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://download.live555.com/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9e1285aa314f9d0d071de4f4c6c1fe8ae2b115170beabb6f43e8a6a312db7b3a"
    sha256 cellar: :any, arm64_sequoia: "4dcdbcd438ff920c5f0aacdac7e6225cd9fb6c27ef70c0f0478d04fc89af1b01"
    sha256 cellar: :any, arm64_sonoma:  "d8a2f414a61d2fb5aa5e4bc134b50142f15c10e9accc33e870a9ec23861024b7"
    sha256 cellar: :any, sonoma:        "87808f9a443feadb52bf760d6144c1c45f1443aed88bb93bf578881bfd491830"
    sha256 cellar: :any, arm64_linux:   "d9dadde38848c21523919807a6130d2c22dfff95a081c91146d6d85ccf53f2c2"
    sha256 cellar: :any, x86_64_linux:  "dccd07720b0c6219a9ac4ce2d1157b631ca4adec5b9f6f1198976999f5856bd6"
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