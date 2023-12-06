class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
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
    sha256 arm64_sonoma:   "a507ca4585ea75e4a5bb40c23ad4d94fe01357e134038b6568bccb5f8d237af4"
    sha256 arm64_ventura:  "494134c5ffbba504bb6ec0d14bf286686fc2aa78212bbb559c22c49e0a3bff71"
    sha256 arm64_monterey: "c653d91a6d669787c5435c94f662f6ca09092fd0fd9dabefbcc808cb810dbbaa"
    sha256 sonoma:         "696ddf4bb8f04054a8583d6c64b6f88662b20167d3f3bf24ced945371dfea06f"
    sha256 ventura:        "656b3c38d75d82222e3ef4044a41b3a9a63e727d1c3284226044529ddb15dd28"
    sha256 monterey:       "a935c82c03ad1aa4877d0e2ee89bfad09d616a31f5e27a90c2051cb259b13000"
    sha256 x86_64_linux:   "c68350e893c7e0af961784e1648b43061d69129ee48b3429b2a9a9da0869e2d3"
  end

  depends_on "i686-elf-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.12"
  depends_on "xz" # required for lzma support

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "i386-elf"
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
    system Formula["i686-elf-gcc"].bin/"i686-elf-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
                 shell_output("#{bin}/i386-elf-gdb -batch -ex 'info address _start' a.out")
  end
end