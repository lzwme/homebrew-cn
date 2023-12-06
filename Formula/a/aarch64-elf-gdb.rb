class Aarch64ElfGdb < Formula
  desc "GNU debugger for aarch64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-14.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-14.1.tar.xz"
  sha256 "d66df51276143451fcbff464cc8723d68f1e9df45a6a2d5635a54e71643edb80"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_sonoma:   "065450534767b3ec1d9fbeca9110a0dd868bfc998db8be9fb475704107952504"
    sha256 arm64_ventura:  "f9ea3aeff239d3ba7ddd1f0aaca076733677bd986ce279ef68b9b90ca8fca4cc"
    sha256 arm64_monterey: "006e36da597f1b61a54ab821681fa4e4ac60088145fec620f9c6405573c9547d"
    sha256 sonoma:         "04495b2b2e32e858a669556a40ad248d65c84e00d413ce5b4e7e8b1155782af0"
    sha256 ventura:        "c09878cda47e647ee836b2c40b228ac09f4bbde2aa3329a2544e5a002dbdec7d"
    sha256 monterey:       "5de4468cb0c77e443654e9a56308b436155ec8b93eaa79a7d1b57e39ded0ee02"
    sha256 x86_64_linux:   "cce543b130cb30ba013fda6eae561373ecd5afd79945d4fb09e43f2b90e80578"
  end

  depends_on "aarch64-elf-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.12"
  depends_on "xz" # required for lzma support

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "aarch64-elf"
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
    system "#{Formula["aarch64-elf-gcc"].bin}/aarch64-elf-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/aarch64-elf-gdb -batch -ex 'info address _start' a.out")
  end
end