class X8664ElfBinutils < Formula
  desc "GNU Binutils for x86_64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.43.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.43.tar.bz2"
  sha256 "fed3c3077f0df7a4a1aa47b080b8c53277593ccbb4e5e78b73ffb4e3f265e750"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sonoma:   "030fa33de78861c8a99f02021777810b7df5d416b498690f8752ca8b52d3539d"
    sha256 arm64_ventura:  "a0f14364664ffab038923b6ce86e072ddeec0583145744ebfd9d3b9a041be614"
    sha256 arm64_monterey: "4b13812f6da11cc1a413ba3b9cc8fa9219f85668e144bbb669c69e399d1927e7"
    sha256 sonoma:         "5fbbb472a6aca42bbab966af688a1bd4c4cc44a3345f0c569b2fdb8bd8dcb708"
    sha256 ventura:        "a04e4374a04e09f063802e50ab0050b1b3cf271c20e4a538a4d5493a47c6dd91"
    sha256 monterey:       "3d5f0c56005d2c169f6553fb923d2a1424f8846b20e01ba83d082d317ee501f2"
    sha256 x86_64_linux:   "2fa3e69fac956787190f45c0117d69804473728fdd1253e2190ca7ddbf372bb2"
  end

  depends_on "pkg-config" => :build
  depends_on "zstd"

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
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
    (testpath/"test-s.s").write <<~EOS
      .section .data
      .section .text
      .globl _start
      _start:
          movl $1, %eax
          movl $4, %ebx
          int $0x80
    EOS

    system bin/"x86_64-elf-as", "--64", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf64-x86-64",
      shell_output("#{bin}/x86_64-elf-objdump -a test-s.o")
  end
end