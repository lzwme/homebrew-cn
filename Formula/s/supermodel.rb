class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://ghfast.top/https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20261012-git-7a7e23c.tar.gz"
  version "0.3a-20261012-git-7a7e23c"
  sha256 "e277b395feef252cd0352bc712ef2ee1e8b54d0248231d85f0d3df7c7e26550f"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "33e14cfef73757d845f0c8a573e5e1ffe7ce5571a689c746f442f356b3372895"
    sha256 cellar: :any, arm64_tahoe:       "f9cc0d0bbc7438de1605454a3527744dc688174c7fac7e5426edccc147b548df"
    sha256 cellar: :any, arm64_sequoia:     "a837ae48e4b8449d68485d93bb1df5f396a30c2d5086ae219a6bd2f13fdcca2d"
    sha256 cellar: :any, arm64_linux:       "189852bf16c93493e101fa4125eb0063190c57b5234c5f5a262044f9cc5fa917"
    sha256 cellar: :any, x86_64_linux:      "2da37a3a876e792dc6e25584168e1483472745bedf7a2823051f2ac5ed69a15f"
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