class X8664ElfBinutils < Formula
  desc "GNU Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  sha256 "860daddec9085cb4011279136fc8ad29eb533e9446d7524af7f517dd18f00224"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "b476d6471119dc3e6421ee4b805ece415edd9ae513fe2516bea71c6dc161bbaa"
    sha256 arm64_sequoia: "2c588a97072b2977fbdca42d4a54df688667127f79f0c0d39bf1b6c4123d70bc"
    sha256 arm64_sonoma:  "e4e2ca67039996a941bfdfcd63a3d51be502a20ba5f13f30ac67e6ce5873eac4"
    sha256 sonoma:        "725ada1ba540126bbd25b11f601b064b366ec7dedc9405c835662cf55d1f0307"
    sha256 arm64_linux:   "b46d2602e5052867f001c683936ddba06957aa93764e1761026a943e49db847e"
    sha256 x86_64_linux:  "727eab2fd909ecef7f4fddf12ee3db81a750ce8d3735b172422395ab5030a2a0"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    target = "x86_64-elf"
    system "./configure", "--target=#{target}",
                          "--enable-targets=x86_64-pep",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}/#{target}",
                          "--infodir=#{info}/#{target}",
                          "--with-system-zlib",
                          "--with-zstd",
                          "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test-s.s").write <<~ASM
      .section .data
      .section .text
      .globl _start
      _start:
          movl $1, %eax
          movl $4, %ebx
          int $0x80
    ASM

    system bin/"x86_64-elf-as", "--64", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf64-x86-64",
      shell_output("#{bin}/x86_64-elf-objdump -a test-s.o")
  end
end