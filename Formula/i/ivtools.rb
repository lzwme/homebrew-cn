class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https:github.comvectaportivtools"
  url "https:github.comvectaportivtoolsarchiverefstagsivtools-2.1.1.tar.gz"
  sha256 "4fa680b9d0fd2af610e9012258e150249d9a8abbc3b1f65eb17d01c959142cfc"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "72e0267959ef39b08acc5ec077e3028dfa4b2c1e170ec53327d4bb476869adfe"
    sha256 arm64_sonoma:  "0a33eff027d01ceaf6f35fbc7554bed89fac9360851796a71f4c1dfaef9d2f12"
    sha256 arm64_ventura: "a42b9d7486543eb0d114226f1d34f16b4883d9b573ff28551e31edf13ff66fc2"
    sha256 sonoma:        "968e072feb82650f7e558232fa7a9894846683acf69315b4d9b4a89ee7ddeed5"
    sha256 ventura:       "0b650994d59f5ad13e180ebe45cd79ab6167914f82c23001c7a510c92407b410"
    sha256 x86_64_linux:  "0c68382badfedbd3cea9375f35555b3ad54f202b2477f663244748cdddbedf3a"
  end

  depends_on "ace"
  depends_on "libx11"
  depends_on "libxext"

  def install
    cp "Makefile.orig", "Makefile"
    ace = Formula["ace"]
    args = %W[--mandir=#{man} --with-ace=#{ace.opt_include} --with-ace-libs=#{ace.opt_lib}]
    system ".configure", *std_configure_args, *args
    system "make"
    system "make", "install"

    # Conflicts with dialog
    mv man3"Dialog.3", man3"Dialog_ivtools.3"

    # Delete unneeded symlink to libACE on Linux which conflicts with ace.
    rm lib"libACE.so" unless OS.mac?
  end

  test do
    system bin"comterp", "exit(0)"
  end
end