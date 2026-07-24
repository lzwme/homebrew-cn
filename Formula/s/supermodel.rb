class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://ghfast.top/https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20260723-git-7c239e0.tar.gz"
  version "0.3a-20260723-git-7c239e0"
  sha256 "328c798279064e00d39ac7ae64517e4b17511d40b5b2babc799fe507e4be24d3"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "657825480ad37cfa6e3046587fc2a79c50fd7fbcac76f84c9738454d6223169c"
    sha256 cellar: :any, arm64_sequoia: "8ceac522c4eafe5bc33b62ab2fe4d7006c7696ed1d873ea05c2f207ae1c1efa7"
    sha256 cellar: :any, arm64_sonoma:  "7fa194b4b4b092d1e691205995eb5550568f5e480acf42c114acd41bf86611e8"
    sha256 cellar: :any, sonoma:        "498137969192802ddaf85864b6f10f4a3a64d2e2fc0cbb50749d6031f95f314e"
    sha256 cellar: :any, arm64_linux:   "c6fde5afab240af5c50f3a3effc97d34987823fa73dd1f5217909b8e3e593ebd"
    sha256 cellar: :any, x86_64_linux:  "1e84b92dd4718a86daf7b65ac74b342e9e93cbcd2d67b244a09007872a5dae57"
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