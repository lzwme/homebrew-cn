class Emacs < Formula
  desc "GNU Emacs text editor"
  homepage "https:www.gnu.orgsoftwareemacs"
  url "https:ftp.gnu.orggnuemacsemacs-29.4.tar.xz"
  mirror "https:ftpmirror.gnu.orgemacsemacs-29.4.tar.xz"
  sha256 "ba897946f94c36600a7e7bb3501d27aa4112d791bfe1445c61ed28550daca235"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 arm64_sequoia: "a35f383006a8934c58a3f45947533572b4a69d8b7694e81324a0d86be5cb0061"
    sha256 arm64_sonoma:  "8d0f4ccf0058a8cb9be4edebb8a177d7a317aaaa7254ce74760ce32ed116b064"
    sha256 arm64_ventura: "9240e15ae452e9f5e815a448e7ac4e918b134aae26cc1655ac7b8c8d3d797edc"
    sha256 sonoma:        "f8b1aaf24a3adbc6bb5346f5ae6f5d231b6df2828c138347f876c899969314dc"
    sha256 ventura:       "7f9a6686383c731a8c8cb849a29311aebc4e1be776b8b66ece8caa489e66e9d1"
    sha256 x86_64_linux:  "157c8853560799970750b0d5759af10b4ea90b110f123714e4f3dbad3d3d4f05"
  end

  head do
    url "https:github.comemacs-mirroremacs.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "gnu-sed" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "texinfo" => :build
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "tree-sitter"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "jpeg-turbo"
  end

  def install
    # Mojave uses the Catalina SDK which causes issues like
    # https:github.comHomebrewhomebrew-coreissues46393
    # https:github.comHomebrewhomebrew-corepull70421
    ENV["ac_cv_func_aligned_alloc"] = "no" if OS.mac? && MacOS.version == :mojave

    args = %W[
      --disable-acl
      --disable-silent-rules
      --enable-locallisppath=#{HOMEBREW_PREFIX}shareemacssite-lisp
      --infodir=#{info}emacs
      --prefix=#{prefix}
      --with-gnutls
      --without-x
      --with-xml2
      --without-dbus
      --with-modules
      --without-ns
      --without-imagemagick
      --without-selinux
      --with-tree-sitter
    ]

    if build.head?
      ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec"gnubin"
      system ".autogen.sh"
    end

    File.write "lispsite-load.el", <<~EOS
      (setq exec-path (delete nil
        (mapcar
          (lambda (elt)
            (unless (string-match-p "Homebrewshims" elt) elt))
          exec-path)))
    EOS

    system ".configure", *args
    system "make"
    system "make", "install"

    # Follow MacPorts and don't install ctags from Emacs. This allows Vim
    # and Emacs and ctags to play together without violence.
    (bin"ctags").unlink
    (man1"ctags.1.gz").unlink
  end

  service do
    run [opt_bin"emacs", "--fg-daemon"]
    keep_alive true
  end

  test do
    assert_equal "4", shell_output("#{bin}emacs --batch --eval=\"(print (+ 2 2))\"").strip
  end
end