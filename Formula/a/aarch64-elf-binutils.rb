class Aarch64ElfBinutils < Formula
  desc "GNU Binutils for aarch64-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.43.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.43.tar.bz2"
  sha256 "fed3c3077f0df7a4a1aa47b080b8c53277593ccbb4e5e78b73ffb4e3f265e750"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sonoma:   "f7142a07823a5ba37c3a78a0c5497766b761d1847177e4c7044c9dd6fb247b56"
    sha256 arm64_ventura:  "97e15ed624ae856019692b13c6e466dc3838188fe24715c2687fa9e569f6e6f6"
    sha256 arm64_monterey: "3b26761e9ad584e219a5810631edc7665f057c20024c070f43ae8816315216b0"
    sha256 sonoma:         "bb32863de2850f0bbb94de7398fcd73d420543a2b173e0413d3b63f30880568f"
    sha256 ventura:        "87574065b21b32f2fe0d835d45e0f7fef3de413b5d9bbcf334d9c0c8f3e404eb"
    sha256 monterey:       "616151737e2db601a721c087b26e0c5883888b8c2c065408d68df1b1f22e832c"
    sha256 x86_64_linux:   "70e7af4ee705a223b111c7bf8a94efcb47949771f1720f8ec2b325a693fb2058"
  end

  depends_on "pkg-config" => :build
  depends_on "zstd"

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "aarch64-elf"
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
          mov x0, #0
          mov x16, #1
          svc #0x80
    EOS
    system bin/"aarch64-elf-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf64-littleaarch64",
                 shell_output("#{bin}/aarch64-elf-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/aarch64-elf-c++filt _Z1fv")
  end
end