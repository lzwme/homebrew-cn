class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://ghfast.top/https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20260928-git-8b4de23.tar.gz"
  version "0.3a-20260928-git-8b4de23"
  sha256 "5b280711e085f77be3abc1dbc436787b729d198e155e48baf2344090557df0bf"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "337c7739887af8e9080077d7d0c12636e5d2d50cd8a000c63695f9143aa4c89e"
    sha256 cellar: :any, arm64_tahoe:       "3c838f9b26a799e3469dab4a36ef6eb935b6a267b7e33e680b617d301963add9"
    sha256 cellar: :any, arm64_sequoia:     "47b326e34dd9ce93e4a6f88a56262f55e4048011cc4fadca02949c18adefca4c"
    sha256 cellar: :any, arm64_linux:       "0029d5f2b5e348f3837cb0c366cf05a4c2918769906c435f631a17151efc98f1"
    sha256 cellar: :any, x86_64_linux:      "ed91fb918c003fb5c3b26a68d4bcd433d545611c68949611d58d57a433c0f505"
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