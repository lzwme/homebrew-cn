class Riscv64ElfBinutils < Formula
  desc "GNU Binutils for riscv64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.43.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.43.tar.bz2"
  sha256 "fed3c3077f0df7a4a1aa47b080b8c53277593ccbb4e5e78b73ffb4e3f265e750"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sonoma:   "bb41245557a3e4d5b35b409245d3a693f8afffbc2886f317b5c6d8ba458fd36b"
    sha256 arm64_ventura:  "116574ebb9547de41d9e31278664487f698cdf65e0a0ec36af5e9664ba2ec9d6"
    sha256 arm64_monterey: "470be33f19ded459eb136d3856266497e8ea0c1216537218cac49d02e66e24d2"
    sha256 sonoma:         "27f819a92e61e53553d2ff802ac890df25de2fd5c09e4c74c6bdf6acbc7e25ee"
    sha256 ventura:        "4163ba8ffd9a756cb71bc1a70326ebbf521bc468a0ef4797ad79aa527e947442"
    sha256 monterey:       "b914388c8286b4cff5d18747a418f318a4d3265e2e2b42241ae8f44fb987b769"
    sha256 x86_64_linux:   "b1070c8770d3b8086b170f9baa68e8c2102d182a83770d1bdbeef9b02a96ad55"
  end

  depends_on "pkg-config" => :build
  depends_on "zstd"

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "riscv64-elf"
    system "./configure", "--target=#{target}",
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
    (testpath/"test-s.s").write <<~EOS
      .section .text
      .globl _start
      _start:
          li a7, 93
          li a0, 0
          ecall
    EOS

    system bin/"riscv64-elf-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf64-littleriscv",
                 shell_output("#{bin}/riscv64-elf-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/riscv64-elf-c++filt _Z1fv")
  end
end