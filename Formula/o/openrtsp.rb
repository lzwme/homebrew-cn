class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2025.10.13.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2025.10.13.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "44eb6ae4ae02ef68a5028d9fc8b70c45b9ba45c058f846b68bc4d32c74355f49"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0a3c6e063bc0c7a4db682023221a0fe7c98934514324836990a89b4fc72d9f1b"
    sha256 cellar: :any,                 arm64_sequoia: "a227bbb94725b9c0c7ef1547f8d5031876c3a78387500801b6738de6c5439c1c"
    sha256 cellar: :any,                 arm64_sonoma:  "48d96a97c3accdde4701c96222d4a9bb5d187fa0b1e6a111e462212cd4c75119"
    sha256 cellar: :any,                 sonoma:        "1277e4fb2385597d0bedcfd393d6c3de3392261b20858867ecdd429385c4cb89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57a6a097724a0bfdb3b203a36f6a0fdc81d3ec2a145a46f6b66296be113ff245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe2070fb69ec821f6a9d574c89937351970b00e37b0b8a24f4a150bab759b62b"
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