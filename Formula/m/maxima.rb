class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.47.0-source/maxima-5.47.0.tar.gz"
  sha256 "9104021b24fd53e8c03a983509cb42e937a925e8c0c85c335d7709a14fd40f7a"
  license "GPL-2.0-only"
  revision 3

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7891cd0ca372b962de86288895169fd8c305e8719a4c0262623ca6817d3db22"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c0465259f360bb9aed287465e16096ae6f3493ac4dedd2e7071616d98735c7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b28f12c27b7834daa1c96e7ab44e9356d1f1769900e379b07c2e248789eaf2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "dcc62ddd6211edbff44c3e6b112d2a2b1b2b480310d798ba92939cabbbde4090"
    sha256 cellar: :any_skip_relocation, ventura:        "c72487fb61ccc14bce343ba6335fba67d315a4228994fb157310a48c349bb0c4"
    sha256 cellar: :any_skip_relocation, monterey:       "36247d484c2e957fd895a3b1ad72c0891550ab6b1e36aaead0192198422f0092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb0da5c5a330a5b589dcd4533dc0afe9b0f2f8f7e1e06511427e4f2511bf48fe"
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