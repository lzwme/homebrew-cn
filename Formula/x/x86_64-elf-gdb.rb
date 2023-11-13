class X8664ElfGdb < Formula
  desc "GNU debugger for x86_64-elf cross development"
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
    sha256 arm64_sonoma:   "b10b8e35e9213541f13cf7a7bc55e88389ca2f774c45fe4de429a1fe9251fa1f"
    sha256 arm64_ventura:  "3902b597afacce321c4cbdcfa63ed0d8b272881dd1f76e344de0ff8a898214ea"
    sha256 arm64_monterey: "8bfeeebe641e2ede21c54366b00ec6abd15d637d37b1f91c5cf89418f000bdcc"
    sha256 sonoma:         "4736e1e0fb8ffa4961f43c0a71bc0a80d6c127140df7240101e682e3ae24fa1b"
    sha256 ventura:        "62248e378aff48511665d10bc9fc52ec4f87c2cc571002f4ac502a3e38fc2c90"
    sha256 monterey:       "6ca45e5ca701a964b08f77804b3ed0ec999815b4d97200313cfb84bc58d4c214"
    sha256 x86_64_linux:   "d8ccc8b25e39e204e0780ae5f4bfa357b87558a6d4546ebf5c7fee40a4a4c22a"
  end

  depends_on "x86_64-elf-gcc" => :test
  depends_on "gmp"
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