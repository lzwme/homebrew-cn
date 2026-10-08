class Aarch64ElfGdb < Formula
  desc "GNU debugger for aarch64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftpmirror.gnu.org/gdb/gdb-18.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gdb/gdb-18.1.tar.xz"
  sha256 "cd9fc3fe2b47743840e42c1592d3d87f8302eb18639c0b8b4ba0898002e2348f"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_golden_gate: "503d596f5615aa4347b7130c5b2631f6d82821206e1bdcf35593745075c1569c"
    sha256 arm64_tahoe:       "35b9a904b49aa5f6a59eaaf18d06c8dd8641be7bf7dcfd9660d2fb535aa048b8"
    sha256 arm64_sequoia:     "b1ab40dec2e3bf3abd4583555d3212bbf8756c60dfa35f7b88a47223372b4be6"
    sha256 arm64_linux:       "03b905f671e8bed5ccd761641ea3ac6f072233aa090ac09c9daf01689959daa6"
    sha256 x86_64_linux:      "f04148decadce870043397548a52b4911281e934bfb0aab662bbd2d9b5602a73"
  end

  depends_on "pkgconf" => :build
  depends_on "aarch64-elf-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ncurses" # https://github.com/Homebrew/homebrew-core/issues/224294
  depends_on "python@3.14"
  depends_on "readline"
  depends_on "xz" # required for lzma support
  depends_on "zstd"

  uses_from_macos "expat", since: :sequoia # minimum macOS due to python

  # Workaround for https://github.com/Homebrew/brew/issues/19315
  on_sequoia :or_newer do
    on_intel do
      depends_on "expat"
    end
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    target = "aarch64-elf"
    args = %W[
      --target=#{target}
      --datarootdir=#{share}/#{target}
      --includedir=#{include}/#{target}
      --infodir=#{info}/#{target}
      --mandir=#{man}
      --disable-binutils
      --disable-nls
      --enable-tui
      --with-curses
      --with-expat
      --with-lzma
      --with-python=#{python3}
      --with-system-readline
      --with-system-zlib
      --with-zstd
    ]

    mkdir "build" do
      system "../configure", *args, *std_configure_args
      ENV.deparallelize # Error: common/version.c-stamp.tmp: No such file or directory
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb"
    end
  end

  test do
    (testpath/"test.c").write "void _start(void) {}"
    system "#{formula_opt_bin("aarch64-elf-gcc")}/aarch64-elf-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/aarch64-elf-gdb -batch -ex 'info address _start' a.out")
  end
end