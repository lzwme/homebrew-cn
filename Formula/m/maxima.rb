class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.47.0-source/maxima-5.47.0.tar.gz"
  sha256 "9104021b24fd53e8c03a983509cb42e937a925e8c0c85c335d7709a14fd40f7a"
  license "GPL-2.0-only"
  revision 11

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3cc7c4795b0a9bb3a39207306b622e8171ee37985c1839cc6e026c8907a9a3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0385dc2cbd3e74d74f4e0352f399e23362500baade294c20ccd79712ed32123"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da6d88509b113a5e449ede1ee24dd26ab94a5096d266a2e8f671fd0dc15271c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "1116807f9d302b43a9c6c280195ca0028219fadc0a436e6e638b4bb4473c90d2"
    sha256 cellar: :any_skip_relocation, ventura:        "68f2c4c7ed78fd52e20a5fece3db65cf9a521554472f3de2f8d8364598a0be4f"
    sha256 cellar: :any_skip_relocation, monterey:       "5678156817094847f81ee8893ec24889a8959bf0846fee72e07991f8ff9e64a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e0e60f025e06dfeece9d67396f41b8a267166a67845ddd83e873f05af89e9a6"
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