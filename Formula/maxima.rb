class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.46.0-source/maxima-5.46.0.tar.gz"
  sha256 "7390f06b48da65c9033e8b2f629b978b90056454a54022db7de70e2225aa8b07"
  license "GPL-2.0-only"
  revision 12

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b376d88ed1f5e3fe2f87827c21fba1cf23c108ec6968122fcc2d309a991c233f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec58473d552390c75eb9eac58926b285147765a8aedbec65a224448b2b216697"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16b6179be861c3bf7aa2c6e1b60a59ce37cf47700dbeaf5acb1151883d1f87c6"
    sha256 cellar: :any_skip_relocation, ventura:        "87c214ad963dd69e1afe5f9d7f8aee7d37d1da705e54ccc3dc6a340767c696e8"
    sha256 cellar: :any_skip_relocation, monterey:       "324554fb74615bb16b64285974f2f70b63f8e91170b1a5d5dce91c9e07ccc518"
    sha256 cellar: :any_skip_relocation, big_sur:        "8909585aec55bb66b8958b8c6558ba2ca7a8133c54e683bee3e11b18bc00db9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a25500a9df9047ac3150f5113809f029c94b6af528a1e568836f878034cd56d"
  end

  depends_on "gawk" => :build
  depends_on "gnu-sed" => :build
  depends_on "perl" => :build
  depends_on "texinfo" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "rlwrap"
  depends_on "sbcl"

  def install
    ENV["LANG"] = "C" # per build instructions
    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--prefix=#{prefix}",
           "--enable-gettext",
           "--enable-sbcl",
           "--with-emacs-prefix=#{share}/emacs/site-lisp/#{name}",
           "--with-sbcl=#{Formula["sbcl"].opt_bin}/sbcl"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/maxima", "--batch-string=run_testsuite(); quit();"
  end
end