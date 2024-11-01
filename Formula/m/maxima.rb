class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.47.0-source/maxima-5.47.0.tar.gz"
  sha256 "9104021b24fd53e8c03a983509cb42e937a925e8c0c85c335d7709a14fd40f7a"
  license "GPL-2.0-only"
  revision 15

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed07dd0f12787938985bfb31711b8000e897721f48dd54ea8592f160bed697be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c197a1f2216b011080ea3e0fba4127f5e09ba640ce2593c47564b6f3f1812a50"
    sha256 cellar: :any_skip_relocation, sonoma:        "801272c8def85f82fb0b0e8458ed5d8c6a1df9465551fe6ff894b40c605c43bf"
    sha256 cellar: :any_skip_relocation, ventura:       "e53be174ead08f80e2c30978dc2d47c6a9d317c9de8c783c5f679dd2f3df92b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "901d3f91d631594946e7032de73108f8384981d9ab1cd33bedb4875993f1707c"
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