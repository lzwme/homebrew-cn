class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://ghfast.top/https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20261023-git-58d4b87.tar.gz"
  version "0.3a-20261023-git-58d4b87"
  sha256 "3094cd731199776ee0a652a90a7cb52ca3eda0a78a2778c18b60939e70a048da"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d6fbd44774593d74221f8df2e91a0e633fb3dc86fcee1ca0a57169bd646a2af3"
    sha256 cellar: :any, arm64_tahoe:       "59fecc26851bb6fbff4dd59bd93267c1028100c229e91c61f8c650ccf1adeb4a"
    sha256 cellar: :any, arm64_sequoia:     "6fc02625df1beaf288f71e536a2d21c3b0d263b763bf57754e3ca8cc15a8a095"
    sha256 cellar: :any, arm64_linux:       "38878e0162e6546caa526ebfaa133213d4ab40d7cfb75d9982e80f687963db48"
    sha256 cellar: :any, x86_64_linux:      "d50ba57c688da13e4f095b835f28747cc360726d166ccd8ecef344b54ca02f53"
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