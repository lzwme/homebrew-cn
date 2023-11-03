class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftp.gnu.org/gnu/gawk/gawk-5.3.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gawk/gawk-5.3.0.tar.xz"
  sha256 "ca9c16d3d11d0ff8c69d79dc0b47267e1329a69b39b799895604ed447d3ca90b"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/gawk.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "0ef661ff666f91dc709142739643045cdb0d5e551ebd50e291ff5aba6eb618cc"
    sha256 arm64_ventura:  "e4d8d214cf4fbb002e8e126f67cf18846920133b4a65ed8ba2ad468cc49209e3"
    sha256 arm64_monterey: "e467ce97a8c5a7900696215c9b47ac0e1b995ff341248de063e743cd2e6c7e81"
    sha256 sonoma:         "5b86d052d87f04b68db3f72000edb6c685c88ac1b7ffa0f895ca8273f6ddef06"
    sha256 ventura:        "961cdc2469d6024f727f9ed6565aeec04e33770a53350109461389366a33d01e"
    sha256 monterey:       "2c31bf294df4959ff3dadb71268416885aaa52ba25ece4dfc79b617ab5ce3f6b"
    sha256 x86_64_linux:   "3027c2f8c9192fa35085eeadb6c88b1aa9f577660a7955b0a30f7ca2121c34ab"
  end

  depends_on "gettext"
  depends_on "mpfr"
  depends_on "readline"

  on_linux do
    conflicts_with "awk", because: "both install an `awk` executable"
  end

  def install
    system "./bootstrap.sh" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-libsigsegv-prefix
    ]
    # Persistent memory allocator (PMA) is enabled by default. At the time of
    # writing, that would force an x86_64 executable on macOS arm64, because a
    # native ARM binary with such feature would not work. See:
    # https://git.savannah.gnu.org/cgit/gawk.git/tree/README_d/README.macosx?h=gawk-5.2.1#n1
    args << "--disable-pma" if OS.mac? && Hardware::CPU.arm?
    system "./configure", *args

    system "make"
    if which "cmp"
      system "make", "check"
    else
      opoo "Skipping `make check` due to unavailable `cmp`"
    end
    system "make", "install"

    (bin/"awk").unlink if OS.mac?
    (libexec/"gnubin").install_symlink bin/"gawk" => "awk"
    (libexec/"gnuman/man1").install_symlink man1/"gawk.1" => "awk.1"
    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        GNU "awk" has been installed as "gawk".
        If you need to use it as "awk", you can add a "gnubin" directory
        to your PATH from your ~/.bashrc and/or ~/.zshrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    output = pipe_output("#{bin}/gawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end