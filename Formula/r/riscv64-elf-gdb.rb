class Riscv64ElfGdb < Formula
  desc "GNU debugger for riscv64-elf cross development"
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
    sha256 arm64_sonoma:   "4eaf81306cb8cbb0452e58088f8e94447df0140e8b845bd0820e2285dc8f021d"
    sha256 arm64_ventura:  "d860aab7c506cd19b4dcce105f7192e5bae9c35a1518ef1db94f60b01c70ce94"
    sha256 arm64_monterey: "f474a8b2c8ed6a995bcff8d5c945c395797daff554c4119c4edafb7433380502"
    sha256 sonoma:         "5d2fc92bc2886eb967f35fdd7e8af836ad56edb7ceaae07594075d5222cabf1d"
    sha256 ventura:        "ce2f80bf63d6761f26bdb734972c339d48547ce594cec3df90a61c9854456cd4"
    sha256 monterey:       "1a6fc514de450cb8b5eb25636255c0ca1c1ed6ab979ac35b92dfda9625f5c57d"
    sha256 x86_64_linux:   "203aaf3dbe9f4508285205325f2077f5d22010d58a083f386ac13c7a616ac0f8"
  end

  depends_on "riscv64-elf-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.12"
  depends_on "xz" # required for lzma support

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "riscv64-elf"
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
    system "#{Formula["riscv64-elf-gcc"].bin}/riscv64-elf-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/riscv64-elf-gdb -batch -ex 'info address _start' a.out")
  end
end