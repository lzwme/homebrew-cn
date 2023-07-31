class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https://www.gnu.org/software/emacs/"
  url "https://ftp.gnu.org/gnu/emacs/emacs-29.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/emacs/emacs-29.1.tar.xz"
  sha256 "d2f881a5cc231e2f5a03e86f4584b0438f83edd7598a09d24a21bd8d003e2e01"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "43c2791523dc17eb04a2667bd810c255a150b102c6d6de5fb2791b8163c404cd"
    sha256 arm64_monterey: "9e52f2e423712bcf2a898d3769e23081e604c9f49de29697fc1f3438f88a7966"
    sha256 arm64_big_sur:  "9feabda998797b79721cfc083595ab5cc7651a652667930a829511cef129cb5c"
    sha256 ventura:        "d94d3ab718f142a223f633864db9d2b0f351908ffeafb89f5db0a57ede797780"
    sha256 monterey:       "901635f095aa23cb14fb3eed6b53c3730e9fa60172f9be8311c62d5ba2876258"
    sha256 big_sur:        "bd35621de343972b9ae7cca744e428eac34ba5a3075ce4e4d3ec5bb12078b312"
    sha256 x86_64_linux:   "8f3c35a37ba27bade073c54b9da2ec45cba99a7502ec1bb804bbddd2564b6fd6"
  end

  head do
    url "https://github.com/emacs-mirror/emacs.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "gnu-sed" => :build
    depends_on "texinfo" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "jansson"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "jpeg-turbo"
  end

  def install
    # Mojave uses the Catalina SDK which causes issues like
    # https://github.com/Homebrew/homebrew-core/issues/46393
    # https://github.com/Homebrew/homebrew-core/pull/70421
    ENV["ac_cv_func_aligned_alloc"] = "no" if MacOS.version == :mojave

    args = %W[
      --disable-silent-rules
      --enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp
      --infodir=#{info}/emacs
      --prefix=#{prefix}
      --with-gnutls
      --without-x
      --with-xml2
      --without-dbus
      --with-modules
      --without-ns
      --without-imagemagick
      --without-selinux
    ]

    if build.head?
      ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"
      system "./autogen.sh"
    end

    File.write "lisp/site-load.el", <<~EOS
      (setq exec-path (delete nil
        (mapcar
          (lambda (elt)
            (unless (string-match-p "Homebrew/shims" elt) elt))
          exec-path)))
    EOS

    system "./configure", *args
    system "make"
    system "make", "install"

    # Follow MacPorts and don't install ctags from Emacs. This allows Vim
    # and Emacs and ctags to play together without violence.
    (bin/"ctags").unlink
    (man1/"ctags.1.gz").unlink
  end

  service do
    run [opt_bin/"emacs", "--fg-daemon"]
    keep_alive true
  end

  test do
    assert_equal "4", shell_output("#{bin}/emacs --batch --eval=\"(print (+ 2 2))\"").strip
  end
end