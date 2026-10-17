class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://ghfast.top/https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20261016-git-70b1b31.tar.gz"
  version "0.3a-20261016-git-70b1b31"
  sha256 "afab355011d7d0a489848653fcd933ed7fae682bf56c6fd68bbe7e91bdcff785"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "44b02d902a0810f464e09d8d1053d6ffe5218b3da8547e25cfdf85454dd7bb49"
    sha256 cellar: :any, arm64_tahoe:       "12cb1aae5ed5a057b0ed53d2da93a18d0b3a1b3b62065699d33fd0b239fa02d5"
    sha256 cellar: :any, arm64_sequoia:     "611c367952126c8a40dd4baaf80e01ef3592d7cc1b9bbb1907db2d8d7ca6740e"
    sha256 cellar: :any, arm64_linux:       "cfc52c50f8ab394ba4c81c90b7116a9e764c85bdfa84a947c2ee58865b04fd4e"
    sha256 cellar: :any, x86_64_linux:      "d7569aee90e1ea9aff88138576652c831d46a174d472fd5ba615f82e5ffb9d8a"
  end

  depends_on "sdl2-compat"
  depends_on "sdl2_net"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # Not using Makefile.OSX as it uses prebuilt frameworks
    system "make", "-f", "Makefiles/Makefile.UNIX", "BIN_DIR=#{bin}"
  end

  test do
    system bin/"supermodel", "-print-games"
  end
end