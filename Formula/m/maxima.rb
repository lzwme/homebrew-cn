class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.47.0-source/maxima-5.47.0.tar.gz"
  sha256 "9104021b24fd53e8c03a983509cb42e937a925e8c0c85c335d7709a14fd40f7a"
  license "GPL-2.0-only"
  revision 5

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b3bc8a836a5fd10aa5a108870429df1c5672689527e726cf5ab262872d7cf25"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c0f2d1e9f7fa8d9692f80e56dd4b5c2778e60f545983a9282ff712646d03bf5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1408a89bde0e1fb704be05bf3841dde571ab7ae343e23ce00387cb1b53a6a4bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "6375c8792a4e76f33571d8366bfb17d27345445527a85449aa6db1916a4ef2be"
    sha256 cellar: :any_skip_relocation, ventura:        "80e4ea667e218ce6c9e4047448632e184dcf8709f110c37dc08c9fb7e00436a8"
    sha256 cellar: :any_skip_relocation, monterey:       "e106a248aac0b8f4418d2644908e5b6caaccfeaa99b70c6eb9b40fd612dcabf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "503b659710076fbb13649d02e84124ef1ae2bc09551645782338186f90db2510"
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