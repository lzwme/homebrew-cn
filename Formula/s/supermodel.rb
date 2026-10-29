class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://ghfast.top/https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20261028-git-b25b264.tar.gz"
  version "0.3a-20261028-git-b25b264"
  sha256 "7e51b8589109ffcf481592b972936333b8a5407d5e5465e88b0b214c68390595"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "128bb67d9941652813f7bd4af0697996dda727e6dcf1e638a2b145251265ebcb"
    sha256 cellar: :any, arm64_tahoe:       "5bdb721fb47caa94f8c6d8c4c0e7b9e1b288a4ac7670ade5dcd8d134104becf9"
    sha256 cellar: :any, arm64_sequoia:     "382b70656dfe9f488f6986bd63cd0f56e5b3cbd7f24a69c0f7e785542c420a07"
    sha256 cellar: :any, arm64_linux:       "715f18c2aa9fbaaa91099b6246aceb74b9667e3f205b79cf2439a0f9e230ef55"
    sha256 cellar: :any, x86_64_linux:      "88dfa4f75ed93c585232dad286d60ba45b397bb3fcb3c717c147947a05f77068"
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