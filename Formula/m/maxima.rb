class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.48.0-source/maxima-5.48.0.tar.gz"
  sha256 "75af2bf1894df2a17aef8a5c378d72d4d53c669b9f47d60ec5ba8c8676c4aaab"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f9fda5f15ea55a2f249045119c608e6575ed7ba3e52cb6b06f46f764abc906f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3700df94389c71370ba84631894622dc44c007f751ea95c910ad02957b6edc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8893c78aa849c460011c20e0eb237d3737f85437c8b361e202d1fdf123914bf0"
    sha256 cellar: :any_skip_relocation, ventura:       "68c36cea4b1afc58b3957b89026d36b3cc03d107c6261a6d609b0b34f4bfc029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b53439d2bb09d66e5666d62f602c39d73b8fb42028df8dd1773e846fb460d666"
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
    system bin/"maxima", "--batch-string=run_testsuite(); quit();"
  end
end