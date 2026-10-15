class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://ghfast.top/https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20261014-git-12390db.tar.gz"
  version "0.3a-20261014-git-12390db"
  sha256 "bd8cc56715804e50751f24e2da0ec7d370189a285b22c48fb32d87cb28e2694d"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1991c11181f5a86ae681a01997bcc0adb38c8eeeb16d409c4dd60de4f59f6ae6"
    sha256 cellar: :any, arm64_tahoe:       "586e462c2637a586114624428171eb67dec4f8bddae80be79bac207d336f0c2c"
    sha256 cellar: :any, arm64_sequoia:     "f4bc8fa46c6c4cbbd5dc878fb134f4959444d2ae4db52139adad3fa46c268e77"
    sha256 cellar: :any, arm64_linux:       "d1f57231aa6a795eb4ed0af00d78f729a90e0cda19138d9c0853e31640ea8498"
    sha256 cellar: :any, x86_64_linux:      "c18cffad2e291da989dda6c3db0b3f19cf6d0691d10c92170ee4598571384ead"
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