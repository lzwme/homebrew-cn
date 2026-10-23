class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://ghfast.top/https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20261021-git-32c29b0.tar.gz"
  version "0.3a-20261021-git-32c29b0"
  sha256 "d09e075bf019b8be0d88e12a69fed267ba09aef92fa8f2075b4dace57a4a830a"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2ef36cc5296bacbac9eb254ee1e02154c283d27662ba04cc86307219460d997b"
    sha256 cellar: :any, arm64_tahoe:       "053dfc64ee8a4006b065cd3b1f03967526defbc47d64e67349281f2b7cac57b9"
    sha256 cellar: :any, arm64_sequoia:     "69f3d2c40c622866d7d27f18d9a82f39c0b593f92bae39dc29193e09dded2b84"
    sha256 cellar: :any, arm64_linux:       "54248ac9848888e73eb4f7e26322f54e16fd7f3b5e7c6ff7db83c7211ad4ef0b"
    sha256 cellar: :any, x86_64_linux:      "eb97508b130e12693c3442570766672e2e68a99f6a4a1a62b82cc59a3c7e3f3e"
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