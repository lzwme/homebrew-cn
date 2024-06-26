class Make < Formula
  desc "Utility for directing compilation"
  homepage "https://www.gnu.org/software/make/"
  url "https://ftp.gnu.org/gnu/make/make-4.4.1.tar.lz"
  mirror "https://ftpmirror.gnu.org/make/make-4.4.1.tar.lz"
  sha256 "8814ba072182b605d156d7589c19a43b89fc58ea479b9355146160946f8cf6e9"
  license "GPL-3.0-only"

  bottle do
    sha256 arm64_sonoma:   "2cf9b5846e07363681d41819a13d2d9a993a69dd5090bbfae3da182915e777b9"
    sha256 arm64_ventura:  "23e26446ffdefd2b7fe44c559e11ab6bc127abd32233847f4e73bb3de87d98c6"
    sha256 arm64_monterey: "f3c69489afdb2ad686c7674d85deac4fcfdb3f891664c08c5d255af20a6eddcb"
    sha256 arm64_big_sur:  "cdb852c53ed94d31d5f4988338336b004f21857d1ecaa8e84b1c155bf92e0c47"
    sha256 sonoma:         "8c51e1eebb1cb1ae3acc4c52d041b141dd7d1ca005ba0081fd7c47162d4a50db"
    sha256 ventura:        "206c13dc47f17131b1337ed24677b69288c2f03f780d09d1c3e5fd11a41d6ad9"
    sha256 monterey:       "75651f4a57f1a712dfed7ed926de8b4c7f6c728544627ea059304f28455c4bab"
    sha256 big_sur:        "2571cf69a3d123408660797685af0040097b1c273b13dfd0e3653ca1150830e2"
    sha256 x86_64_linux:   "bded8e436d51f10ee36207ec69a0a318fb8583f83a5863f45bb203d3ae055170"
  end

  head do
    url "https://git.savannah.gnu.org/git/make.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build # for autopoint
    depends_on "libtool" => :build
    depends_on "texinfo" => :build
    depends_on "wget" => :build # used by autopull

    uses_from_macos "m4" => :build

    fails_with :clang # fails with invalid arguments sent to compiler
  end

  def install
    if build.head?
      system "./autopull.sh" # downloads gnulib files from git that autogen.sh needs
      system "./autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make", "install"

    if OS.mac?
      (libexec/"gnubin").install_symlink bin/"gmake" =>"make"
      (libexec/"gnuman/man1").install_symlink man1/"gmake.1" => "make.1"
    end

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        GNU "make" has been installed as "gmake".
        If you need to use it as "make", you can add a "gnubin" directory
        to your PATH from your bashrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    (testpath/"Makefile").write <<~EOS
      default:
      \t@echo Homebrew
    EOS

    if OS.mac?
      assert_equal "Homebrew\n", shell_output("#{bin}/gmake")
      assert_equal "Homebrew\n", shell_output("#{opt_libexec}/gnubin/make")
    else
      assert_equal "Homebrew\n", shell_output("#{bin}/make")
    end
  end
end