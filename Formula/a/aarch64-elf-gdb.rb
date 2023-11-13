class Aarch64ElfGdb < Formula
  desc "GNU debugger for aarch64-elf cross development"
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
    sha256 arm64_sonoma:   "c079442c342ce94b213f7551fc57a67c81ac91d1344da58c4aa77f3935bd99ac"
    sha256 arm64_ventura:  "e5fbbe574ba723fe4fcb3f9b3bdadd882750b1b749e72d43a6ad63eb470f5a2e"
    sha256 arm64_monterey: "4c13676f6ae41a761955748c4bfa00ea1f63ec98747562baf70f20cfbad97138"
    sha256 sonoma:         "2bbb1821162de6f90f1d3a5da4b68dfafc376900faf0bbc1a77791b53b5e47a2"
    sha256 ventura:        "92c1733e1328ca927d2ee9c24913b910f2c151d73742d3befc19a04a57548a62"
    sha256 monterey:       "2fc80c9827c68d611d9d8f930f5f83ab196ab85a2190e063e9eb5e356f74530e"
    sha256 x86_64_linux:   "6f4bc10aca712b3983b25ae43d7fe4b0e5b5800dd1d5aedcdd50dc4555cb313f"
  end

  depends_on "aarch64-elf-gcc" => :test
  depends_on "gmp"
  depends_on "python@3.12"
  depends_on "xz" # required for lzma support

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "aarch64-elf"
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
    system "#{Formula["aarch64-elf-gcc"].bin}/aarch64-elf-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/aarch64-elf-gdb -batch -ex 'info address _start' a.out")
  end
end