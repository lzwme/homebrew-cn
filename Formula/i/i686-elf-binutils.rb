class I686ElfBinutils < Formula
  desc "GNU Binutils for i686-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.43.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.43.tar.bz2"
  sha256 "fed3c3077f0df7a4a1aa47b080b8c53277593ccbb4e5e78b73ffb4e3f265e750"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sonoma:   "1d983584854b259dca04c39d6e9c19497c1e3011388a1a5808ef19fa31de8c49"
    sha256 arm64_ventura:  "204b7b836c8edf80d4f06912f29d05bbdbf4b964d1d66ecc92e042eadab11cbe"
    sha256 arm64_monterey: "61c7d5bfee87bb42d28b96623be9196faf6733cbcb24de984c5caeb92bd2dbc3"
    sha256 sonoma:         "c7b7503411278497c68d8d739268c60a98a5d6056344a523f9500cf75c57e182"
    sha256 ventura:        "12931c2219b2682671aa033e7e72bfefbb765ff215b803671bb65240c88de879"
    sha256 monterey:       "be793466526402e3adf56767dd8d82a285757a56ae81e0264ba449ac4996279e"
    sha256 x86_64_linux:   "b56b74e011c71e1c3233ed16f49d07b8c83c9c58ce9e7a977b5197544392b525"
  end

  depends_on "pkg-config" => :build
  depends_on "zstd"

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "i686-elf"
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
      .section .data
      .section .text
      .globl _start
      _start:
          movl $1, %eax
          movl $4, %ebx
          int $0x80
    EOS

    system bin/"i686-elf-as", "--32", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-i386",
      shell_output("#{bin}/i686-elf-objdump -a test-s.o")
  end
end