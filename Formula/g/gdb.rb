class Gdb < Formula
  desc "GNU debugger"
  homepage "https:www.gnu.orgsoftwaregdb"
  url "https:ftp.gnu.orggnugdbgdb-16.2.tar.xz"
  mirror "https:ftpmirror.gnu.orggdbgdb-16.2.tar.xz"
  sha256 "4002cb7f23f45c37c790536a13a720942ce4be0402d929c9085e92f10d480119"
  license "GPL-3.0-or-later"
  head "https:sourceware.orggitbinutils-gdb.git", branch: "master"

  bottle do
    rebuild 1
    sha256 sonoma:       "c595592e4c42917f8eba3065e18362bf7fec8ef3b1840ae73a112f1404c82697"
    sha256 ventura:      "5a62c5a00665a7967495420c857bb9f40af5b2bcdd73d213b36cc7d6ce6d51e3"
    sha256 x86_64_linux: "fd1842ea508afcb72be94f466259cc0e355be3834bb440f5e9acde27cb7734d5"
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.13"
  depends_on "xz" # required for lzma support

  uses_from_macos "expat", since: :sequoia # minimum macOS due to python
  uses_from_macos "ncurses"

  on_macos do
    depends_on arch: :x86_64 # gdb is not supported on macOS ARM
  end

  # Workaround for https:github.comHomebrewbrewissues19315
  on_sequoia :or_newer do
    on_intel do
      depends_on "expat"
    end
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "guile"
  end

  fails_with :clang do
    build 800
    cause <<~EOS
      probe.c:63:28: error: default initialization of an object of const type
      'const any_static_probe_ops' without a user-provided default constructor
    EOS
  end

  def install
    # Fix `error: use of undeclared identifier 'command_style'`
    inreplace "gdbdarwin-nat.c", "#include \"clicli-cmds.h\"",
                                  "#include \"clicli-cmds.h\"\n#include \"clicli-style.h\""

    args = %W[
      --enable-targets=all
      --with-lzma
      --with-python=#{which("python3.13")}
      --disable-binutils
    ]

    mkdir "build" do
      system "..configure", *args, *std_configure_args
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb", "maybe-install-gdbserver"
    end
  end

  def caveats
    on_macos do
      <<~EOS
        gdb requires special privileges to access Mach ports.
        You will need to codesign the binary. For instructions, see:

          https:sourceware.orggdbwikiPermissionsDarwin
      EOS
    end
  end

  test do
    system bin"gdb", bin"gdb", "-configuration"
  end
end