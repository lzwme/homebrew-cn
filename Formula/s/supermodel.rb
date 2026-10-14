class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://ghfast.top/https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20261013-git-0459d98.tar.gz"
  version "0.3a-20261013-git-0459d98"
  sha256 "d42f1871d39550069ca8c7b63367387af0441a4d7cc7e9150ead6e8276aa51ce"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "649a9b76bfa7eac90427f97f470e60cec7e505e865a0c7c9aaa945fd82209e0a"
    sha256 cellar: :any, arm64_tahoe:       "9a7e55d3f7d8b0983b2f83cc758bd635261161d4b1592f8ab596f56a9192768f"
    sha256 cellar: :any, arm64_sequoia:     "e7d1e1e184cb52ad69f871055bf1ded20f9ff6c13f4245daf13cddbf088f6fe2"
    sha256 cellar: :any, arm64_linux:       "f718a78174788a1f3e52d9043d3286331d504d7aaaf223df91e320b29fe0de1e"
    sha256 cellar: :any, x86_64_linux:      "5080822e2ec96904a29b5c6d1eb2fe8c8b02c263db04cbd395fb8da484269041"
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