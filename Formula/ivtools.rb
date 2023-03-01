class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https://github.com/vectaport/ivtools"
  url "https://ghproxy.com/https://github.com/vectaport/ivtools/archive/refs/tags/ivtools-2.0.11d.tar.gz"
  sha256 "8c6fe536dff923f7819b4210a706f0abe721e13db8a844395048ded484fb2437"
  license "MIT"
  revision 6

  bottle do
    sha256 arm64_ventura:  "3bf5b5b67f221d982611087d016d1fa6bc5738c0377e077c5bb7ff1aac9e8420"
    sha256 arm64_monterey: "87c69c86869d1d892f8a6b8c44d2e0bce2dabc2318af2bae6b477e9de4b6de55"
    sha256 arm64_big_sur:  "dd7a1afa85963ad8e8e7ff40ff93ef083b070f73895b90cf69e3978cc4157a7b"
    sha256 ventura:        "fd7358c55d328bf4b601109693af65ef36737a072355f203ffc42c71306a6ddd"
    sha256 monterey:       "fbafffab2abeb3b042b2abae941c99143ca1eeb0f833e5daf75298cc77edbd02"
    sha256 big_sur:        "378ca44654db9a902cda955de1f21b35cbd403374e5cbdabd9ba4938dcfcdaed"
    sha256 x86_64_linux:   "7daac9b9b397ab356a1d4f95653e4c9d15252bde1d4d7a48c7e47e8d32118bdb"
  end

  depends_on "ace"
  depends_on "libx11"
  depends_on "libxext"

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