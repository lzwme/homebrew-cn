class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://ghfast.top/https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20261009-git-b23e6be.tar.gz"
  version "0.3a-20261009-git-b23e6be"
  sha256 "5fe301b9eefc5c833554de27e17363d5ee1bfc1d3a1dfc1e9a6d3ed9883823d0"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c68bac0b37002341e6aed133cff8227f6eef7d418bb6e941a0942da09ad26820"
    sha256 cellar: :any, arm64_tahoe:       "ec85368aff07522267a2f113260a6296e1a9479c897c827e5c46c2f85384957d"
    sha256 cellar: :any, arm64_sequoia:     "ed68d3507ba52f3f45ffe15196c2db6d037be90482e77d274e409feb88ae345b"
    sha256 cellar: :any, arm64_linux:       "7813fdaf6a729b5a8efe57e98b39d60b644b7fd2f21311d5b70c6b4212546e3c"
    sha256 cellar: :any, x86_64_linux:      "c9107db774d8bf9552995cbb71249fe4723c8d5c1d7defc795c3562a701c74e3"
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