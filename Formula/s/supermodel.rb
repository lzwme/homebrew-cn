class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://ghfast.top/https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20261017-git-b05ef21.tar.gz"
  version "0.3a-20261017-git-b05ef21"
  sha256 "233607471c4acc87a74995c202d19984232d01f617361eef25eaed88e4839b09"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3bcc80890e281935d79ad872879f109eef0f9e83b309516c5bf83d0eaf21329a"
    sha256 cellar: :any, arm64_tahoe:       "fd52473f6a2ab7b1c784e299644886e3e58053a58da93e5e5a20f660b455db03"
    sha256 cellar: :any, arm64_sequoia:     "a46db96e476cfe72010e0b51dcdc2cd4ce8dd76155b01ca3e26d2ae94e5c7f84"
    sha256 cellar: :any, arm64_linux:       "78ce8a5cd2f73dc95b47a3697f55155a2c0eaa5752c9664a842a082f415d913d"
    sha256 cellar: :any, x86_64_linux:      "2369157d42cd2402c547534dd9185c12ecc406fa2b91b4f133220d925ea0bfbe"
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