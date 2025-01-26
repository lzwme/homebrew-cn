class GnuWhich < Formula
  desc "GNU implementation of which utility"
  # Previous homepage is dead. Have linked to the GNU Projects page for now.
  homepage "https://savannah.gnu.org/projects/which/"
  url "https://ftp.gnu.org/gnu/which/which-2.22.tar.gz"
  mirror "https://ftpmirror.gnu.org/which/which-2.22.tar.gz"
  sha256 "9f85cde3f2c257021b8508f756704bee6002fa8f5680297d30f186cc1f342af5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7928bd6791212cc8afefc5d00e53e2bde7badff33468376f327ba2d74a00957"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ab019fd8d7a3c9df012134b1a2ce2bb8bfa4470f7af00359b4d0ea767df16a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8035df0864348c6088ae2cdf4b16cf750e045d7fef4bd27bd7b5432047dd126"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5a80fc5dbe8b0e59def3a1a382dfe6cfb524a0510f6f2a8d4d456c2f4838fb5"
    sha256 cellar: :any_skip_relocation, ventura:       "da10c97c2031a30b93ba9a53825833012b4fe8a17739441ee9562f1b6d4f978c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72d67f5b023062866d2883ea9a90e1f1ae3c1d7527bf725013407fb88c851cf9"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make", "install"

    if OS.mac?
      (libexec/"gnubin").install_symlink bin/"gwhich" => "which"
      (libexec/"gnuman/man1").install_symlink man1/"gwhich.1" => "which.1"
    end

    (libexec/"gnubin").install_symlink "../gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        GNU "which" has been installed as "gwhich".
        If you need to use it as "which", you can add a "gnubin" directory
        to your PATH from your bashrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    if OS.mac?
      system bin/"gwhich", "gcc"
      system opt_libexec/"gnubin/which", "gcc"
    else
      system bin/"which", "gcc"
    end
  end
end