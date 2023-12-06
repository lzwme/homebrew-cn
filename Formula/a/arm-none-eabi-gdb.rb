class ArmNoneEabiGdb < Formula
  desc "GNU debugger for arm-none-eabi cross development"
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
    sha256 arm64_sonoma:   "d9b9f391e1896d8be63e0fc81ea181fe8b8c82d26d2db85e939f1e1d07fd680c"
    sha256 arm64_ventura:  "02405e7592d791319cd1a0998bce7b68a391963a214bc9a02f3b6e5c2ccd9715"
    sha256 arm64_monterey: "e89d55677190cd92f0172a382f6e7ba2e7857d5c73f439980f17fcc034b18ed1"
    sha256 sonoma:         "3db8f6701cf9697c2f13745954b241272db0bd04cf16ba41ef71f925be6e3b61"
    sha256 ventura:        "9970824688e0a51fef8c5009fe95fc144e2661679f7dfd6dc2eb6be29e084928"
    sha256 monterey:       "0b125bbbcf7e66e18853f28fc2bad1850064756e2f6e29f1a7836c0ca2f460e9"
    sha256 x86_64_linux:   "f73df14fa10e21fdcec6c03ac19f96a9cf03dcfdc1618f250f015b7f8694a32e"
  end

  depends_on "arm-none-eabi-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.12"
  depends_on "xz" # required for lzma support

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "arm-none-eabi"
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
      --with-python=#{Formula["python@3.12"].opt_bin}/python3.12
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
    system "#{Formula["arm-none-eabi-gcc"].bin}/arm-none-eabi-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/arm-none-eabi-gdb -batch -ex 'info address _start' a.out")
  end
end