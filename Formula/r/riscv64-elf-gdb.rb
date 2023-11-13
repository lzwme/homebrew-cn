class Riscv64ElfGdb < Formula
  desc "GNU debugger for riscv64-elf cross development"
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
    sha256 arm64_sonoma:   "2b054e9cc95b213e898eb9662bb097b85bb0ab499533c9d8684727dd01dd854f"
    sha256 arm64_ventura:  "e11a9be1dfc23c414e463c649028817394faded06e088bff0f68f616157fcf22"
    sha256 arm64_monterey: "a846ed1a8de82c64792a0696b6019c1ab32b0c89a24b6df013587db5c4b979dd"
    sha256 sonoma:         "2862147db6549f3a1ae55f1614e20e04216b5f76a7cb32b6ce59b1d1bb6d5362"
    sha256 ventura:        "5588d978a90db6bb381563c618f37f7d6fb77129e474cd8a6ec116f5245ebab7"
    sha256 monterey:       "715725a8f99752e1a58f34083da2bc416621dd47f875dec8e3bb8e6da1195b68"
    sha256 x86_64_linux:   "0955944f4d720fc4326f247b9b2fb65d08b4ecc77604eae328fa982471bc55f7"
  end

  depends_on "riscv64-elf-gcc" => :test
  depends_on "gmp"
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