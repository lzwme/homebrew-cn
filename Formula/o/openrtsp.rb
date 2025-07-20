class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2025.07.19.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2025.07.19.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "1eaf6d468b51baa8bb8c4cf9197a5b02fb852cfa5937e44f7bbce99cb03ded3d"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "311e293105064ba8a5ebe7aba05ecd0848b6f57d4d01bbd9a9ce7c38c6d72ce9"
    sha256 cellar: :any,                 arm64_sonoma:  "f3470940388a0de07e4a927ad2713540f65667d80f7706ffabff745d782a77b6"
    sha256 cellar: :any,                 arm64_ventura: "746413d23ddf68a9b61b5d38a1eedb47cc07820fc514c45977c224d38fb720b4"
    sha256 cellar: :any,                 sonoma:        "7d81c541d3a9ed0277608ff139be8b3ed73f13da8ec5c351b46f36f3bda56497"
    sha256 cellar: :any,                 ventura:       "ea7ce9786fbe1aedfa398e2912d6da9ddb6e87d97ace1372c3ad69e187c2878e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3502e2564cef592d0c4276d29be4c8c60b9ba2cebd3380f77b3a94e8dece13e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e6843eda9d7a7055068384613368ba92d1843b50293add7e20ce9dd044d74e1"
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