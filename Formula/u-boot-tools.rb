class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2023.07.tar.bz2"
  sha256 "12e921b466ae731cdbc355e6832b7f22bc90b01aeceef9886f98aaba7b394300"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6605bb54ea2fc1be82534b59b64ca0c53e90fa0afb84bf1d7e8195b9c74293bf"
    sha256 cellar: :any,                 arm64_monterey: "8bb152c5df0e68c9b92bdb0cd2ad584cd6c1c4af37216cb925f5d54b1835d89f"
    sha256 cellar: :any,                 arm64_big_sur:  "661afb2351dc71b25eadebaee2728809f028da3c42c63a94411b4a821b341582"
    sha256 cellar: :any,                 ventura:        "c0112c4d60009a15913d78096c228ae9aae3e7926b4798b3ef0a8832253224d6"
    sha256 cellar: :any,                 monterey:       "b778b47c88ee9dcbfcddb1d8dc439a6392e03e6e74ee49e0c69d21b7ece84826"
    sha256 cellar: :any,                 big_sur:        "d24371889844d8c79a42c31a8324909081e8690f283381f3c1b98c17ad84e2e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eedc4edd82ae71bf0ee0d226993f9658b8910fd039ba5d4e193819b3bdbddf60"
  end

  depends_on "coreutils" => :build # Makefile needs $(gdate)
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    # Replace keyword not present in make 3.81
    inreplace "Makefile", "undefine MK_ARCH", "unexport MK_ARCH"

    # Disable mkeficapsule
    inreplace "configs/tools-only_defconfig", "CONFIG_TOOLS_MKEFICAPSULE=y", "CONFIG_TOOLS_MKEFICAPSULE=n"

    system "make", "tools-only_defconfig"
    system "make", "tools-only", "NO_SDL=1"
    bin.install "tools/mkimage"
    bin.install "tools/dumpimage"
    man1.install "doc/mkimage.1"
  end

  test do
    system bin/"mkimage", "-V"
    system bin/"dumpimage", "-V"
  end
end