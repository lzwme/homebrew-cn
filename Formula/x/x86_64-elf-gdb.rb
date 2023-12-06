class X8664ElfGdb < Formula
  desc "GNU debugger for x86_64-elf cross development"
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
    sha256 arm64_sonoma:   "41b901263e72d76fe61c64c424daf10460a3bcf34bec8907deabe30f3d89d51c"
    sha256 arm64_ventura:  "137d38ebe803df4a60ff59824a905f9e6825265a9d07802707d9a66a61f84482"
    sha256 arm64_monterey: "7dfd4c3fca9c8381e23b1ff1d019249e0196ad4fc865e5838e0578c1277b1eb6"
    sha256 sonoma:         "75da948dbee0b08eecc3f4f9ae12ddb0b333b1f5ac48e43cc104072398d6c524"
    sha256 ventura:        "647ebaa39a69d360a4a2cc077aff6e4deadff15abf05adffdddbf3df936ffa31"
    sha256 monterey:       "e19f154dd80e756fd581eae08c8094427adaf38489da33cd837a27815c3005c8"
    sha256 x86_64_linux:   "804a4bb75b4fe64f5310d5bbb8396c1016215e66a7e28cda4d38fa9c5f4dcb4b"
  end

  depends_on "x86_64-elf-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.12"
  depends_on "xz" # required for lzma support

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "x86_64-elf"
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
    system "#{Formula["x86_64-elf-gcc"].bin}/x86_64-elf-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/x86_64-elf-gdb -batch -ex 'info address _start' a.out")
  end
end