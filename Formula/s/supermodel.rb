class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://ghfast.top/https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20261025-git-1481545.tar.gz"
  version "0.3a-20261025-git-1481545"
  sha256 "8d9161113d01dc7c301b406a51eeac7ca03fbd5c7daacee4d8cd31f673598969"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "65c8d985274c577eaf5a7bacac10ec1bc6dcd5900d7645b1162ddea9f06223cb"
    sha256 cellar: :any, arm64_tahoe:       "2d6f16badd449e2b1f6a1d20e86ca259d6cee38203242276bc5a43b057b2835e"
    sha256 cellar: :any, arm64_sequoia:     "8b2c9b03c47a239786f62fd6f43c929822810f41367d7f490f0538206c73863b"
    sha256 cellar: :any, arm64_linux:       "4b0b9cfd60adb151e3438026f3c611829a70c0fed21675bdd51da5b9e12a5d6d"
    sha256 cellar: :any, x86_64_linux:      "5c66a91c9877d87ab57199b174c845ff9c8ed1e66f47e72d6e90bb0c9b03e3d8"
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