class ArmNoneEabiBinutils < Formula
  desc "GNU Binutils for arm-none-eabi cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.43.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.43.tar.bz2"
  sha256 "fed3c3077f0df7a4a1aa47b080b8c53277593ccbb4e5e78b73ffb4e3f265e750"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sonoma:   "1e4211c5ab5b3db94ce27a577dd6e5a9b06b209ea9e5ea4236bc7c9dbe01e323"
    sha256 arm64_ventura:  "925c7a449417e6c6ab2a89e08505331b108df10add1876e7d906374fc7b66010"
    sha256 arm64_monterey: "9eff79f26fb906420c84a4161b3d6f6cf6bfad19f983a34af5e3a09f794b8522"
    sha256 sonoma:         "5fb9a14c12312bb19c948af3a2a3d7f155d5cfd9ebca7954c96fcc9117478f1a"
    sha256 ventura:        "fb10fe50de04a9cec43048b276937cc05dffde48ed16ba5338396315f45c1417"
    sha256 monterey:       "8069d712f9741178760fab6eebf1b9fac0c87dedde6cb223d98a08cd9ad197f9"
    sha256 x86_64_linux:   "2b8f215b6108228917ff16d984611e2cb10624e6fdbfcc331a231b34b74898dd"
  end

  depends_on "pkg-config" => :build
  depends_on "zstd"

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "arm-none-eabi"
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
          mov r1, #0
          mov r2, #1
          svc #0x80
    EOS

    system bin/"arm-none-eabi-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-littlearm",
                 shell_output("#{bin}/arm-none-eabi-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/arm-none-eabi-c++filt _Z1fv")
  end
end