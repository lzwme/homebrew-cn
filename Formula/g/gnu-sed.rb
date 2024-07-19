class GnuSed < Formula
  desc "GNU implementation of the famous stream editor"
  homepage "https://www.gnu.org/software/sed/"
  url "https://ftp.gnu.org/gnu/sed/sed-4.9.tar.xz"
  mirror "https://ftpmirror.gnu.org/sed/sed-4.9.tar.xz"
  sha256 "6e226b732e1cd739464ad6862bd1a1aba42d7982922da7a53519631d24975181"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca2fd8e6b23712c14bfb84c584f0ac08f58f34e66ebfcddb9da59e38f308ed3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c70b2b3bd8b11457e19fc450c330da321ab4270023452578ea95fb01f618540a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e3b5d286e0e24f8a592ae909c2816f59c5b72ef21973f4213a1758421c6dcf2"
    sha256 cellar: :any_skip_relocation, sonoma:         "5831636dc3635c4e76a229dded92d1da402fc03fd92261179e2c874d6bfff810"
    sha256 cellar: :any_skip_relocation, ventura:        "292fdd497666624a749327d262b9d61e33a72f4dfe994ce8212dc8b512037761"
    sha256 cellar: :any_skip_relocation, monterey:       "1d5ad0f2edb63fe1d0b7de7f6a370643be971c20702839388d1ca05c4e74f5e4"
    sha256                               x86_64_linux:   "3989ab1717786e2d9ac9d1035f794cd741372131c1f830e2a76722f085872cfb"
  end

  conflicts_with "ssed", because: "both install share/info/sed.info"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
    ]

    args << if OS.mac?
      "--program-prefix=g"
    else
      "--without-selinux"
    end
    system "./configure", *args
    system "make", "install"

    if OS.mac?
      (libexec/"gnubin").install_symlink bin/"gsed" =>"sed"
      (libexec/"gnuman/man1").install_symlink man1/"gsed.1" => "sed.1"
    end

    (libexec/"gnubin").install_symlink "../gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        GNU "sed" has been installed as "gsed".
        If you need to use it as "sed", you can add a "gnubin" directory
        to your PATH from your bashrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    (testpath/"test.txt").write "Hello world!"
    if OS.mac?
      system "#{bin}/gsed", "-i", "s/world/World/g", "test.txt"
      assert_match "Hello World!", File.read("test.txt")

      system "#{opt_libexec}/gnubin/sed", "-i", "s/world/World/g", "test.txt"
    else
      system "#{bin}/sed", "-i", "s/world/World/g", "test.txt"
    end
    assert_match "Hello World!", File.read("test.txt")
  end
end