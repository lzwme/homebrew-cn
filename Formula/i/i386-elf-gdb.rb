class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-13.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-13.2.tar.xz"
  sha256 "fd5bebb7be1833abdb6e023c2f498a354498281df9d05523d8915babeb893f0a"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "6e6ec30907123d627334dcc3a274d8a6a49bc38b183994b80c1548dc88df0b0d"
    sha256 arm64_ventura:  "04747e8ea7ea67b2b359aec44bdb7973882238bfa5875fdaacad6402fea5eacd"
    sha256 arm64_monterey: "fd58ed1c1b40b86f8a7469aa9b111124b62c368f21f9127c924a149bfec74426"
    sha256 sonoma:         "818a24f4556e1ffd16e0c86d9b694855455a0d7a05ae3778e342b128c30fb44a"
    sha256 ventura:        "6548064be32454df6e80991675abfb80d17ef718c76cca2a82c966cdf283eb82"
    sha256 monterey:       "2a8550dd4acf5be7dd83b6a1344a57e2347d6e0096cf9bca8e9875a88c1d0a56"
    sha256 x86_64_linux:   "8902ec4589ec3d97754542038ec8c4790dbdb67194c8d2a3c789edf9c71e8dbb"
  end

  depends_on "i686-elf-gcc" => :test
  depends_on "gmp"
  depends_on "python@3.12"
  depends_on "xz" # required for lzma support

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "i386-elf"
    args = %W[
      --target=#{target}
      --prefix=#{prefix}
      --datarootdir=#{share}/#{target}
      --includedir=#{include}/#{target}
      --infodir=#{info}/#{target}
      --mandir=#{man}
      --disable-debug
      --disable-dependency-tracking
      --with-lzma
      --with-python=#{which("python3.12")}
      --with-system-zlib
      --disable-binutils
    ]

    mkdir "build" do
      system "../configure", *args
      ENV.deparallelize # Error: common/version.c-stamp.tmp: No such file or directory
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb"
    end
  end

  test do
    (testpath/"test.c").write "void _start(void) {}"
    system Formula["i686-elf-gcc"].bin/"i686-elf-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
                 shell_output("#{bin}/i386-elf-gdb -batch -ex 'info address _start' a.out")
  end
end