class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https://github.com/vectaport/ivtools"
  url "https://ghproxy.com/https://github.com/vectaport/ivtools/archive/refs/tags/ivtools-2.0.11d.tar.gz"
  sha256 "8c6fe536dff923f7819b4210a706f0abe721e13db8a844395048ded484fb2437"
  license "MIT"
  revision 7

  bottle do
    sha256 arm64_ventura:  "9b81b68267116028b0074ebc5b808c53b3cf1ff088c56623f61d0122730c0344"
    sha256 arm64_monterey: "b078b648a87d1a3141c6b8b91393b6bffc6cb023a063ebe2404ade5a64dbbfe6"
    sha256 arm64_big_sur:  "f19b19404161051a55bce2415c08b982b1b5bbbba3047d1cbe400d5c4035cceb"
    sha256 ventura:        "5cf3f13a4e3d798ba36e1eb26938e49eb65f583dc760d800654634aea7669199"
    sha256 monterey:       "ac84fb1792b8b03ffc5065c62732cb5d410504e1def52ded12277a0954797fde"
    sha256 big_sur:        "f0e75644da681b82d5790a24a61e151f7f9b936962a1c300412d172ff4671f58"
    sha256 x86_64_linux:   "cc284693fc7f015cbb6154cb656fa03b6a9a7f5ad9f3e319a19436660b41acef"
  end

  depends_on "ace"
  depends_on "libx11"
  depends_on "libxext"

  # patch for building with c++14
  # upstream PR ref, https://github.com/vectaport/ivtools/pull/19
  patch do
    url "https://github.com/vectaport/ivtools/commit/b7594a707b38e080157a2f531d48e5e5bacac61c.patch?full_index=1"
    sha256 "6b3ec7347b3e282ac0bf3171d248d3bbdfea566a3eaab36ef9c162a14371e853"
  end

  def install
    cp "Makefile.orig", "Makefile"
    ace = Formula["ace"]
    args = %W[--mandir=#{man} --with-ace=#{ace.opt_include} --with-ace-libs=#{ace.opt_lib}]
    system "./configure", *std_configure_args, *args
    system "make"
    system "make", "install"

    # Conflicts with dialog
    mv man3/"Dialog.3", man3/"Dialog_ivtools.3"

    # Delete unneeded symlink to libACE on Linux which conflicts with ace.
    rm lib/"libACE.so" unless OS.mac?
  end

  test do
    system "#{bin}/comterp", "exit(0)"
  end
end