class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://ghfast.top/https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20261018-git-ddbc306.tar.gz"
  version "0.3a-20261018-git-ddbc306"
  sha256 "2214ee88612210f40a02480893c162740522c7f4a10303bf61b5d00a23f5b6bb"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f92587120e7379e487bdc1dfc68587c10641ab9b3799351e1cd4e20e8dd2b5b7"
    sha256 cellar: :any, arm64_tahoe:       "3c5132bac93e5090e7423352044e9830d69fb149bc3474a581ef1077e7754940"
    sha256 cellar: :any, arm64_sequoia:     "33a867ebcf09c0c529423cab252c1afb3e0d94c9496c81cc4aed29aa4d8e2395"
    sha256 cellar: :any, arm64_linux:       "78de287ff74ba9296e961c42ab0b9859a5583fbaefb17c72cf13dd04144229ec"
    sha256 cellar: :any, x86_64_linux:      "1fc2aa1ce2991926098b858bdd6561f63745cf895d590a05c703e824c39b0ca8"
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