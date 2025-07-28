class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.47.0-source/maxima-5.47.0.tar.gz"
  sha256 "9104021b24fd53e8c03a983509cb42e937a925e8c0c85c335d7709a14fd40f7a"
  license "GPL-2.0-only"
  revision 24

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0baad758819ee1b8a62e4af538ca19697e57abbd0bae2dd9f5717660e9e89af2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a30024b3116dcc353412c3c6a482563a328f84d2e5f18fc0ad3a0820a508c92f"
    sha256 cellar: :any_skip_relocation, sonoma:        "40768fdadb67db8e84ce1ef700e5091b82ce35aa68c370f8c85429a28c598c04"
    sha256 cellar: :any_skip_relocation, ventura:       "011a560629d8bcf049e6078010df96775c5df142645e7736e1894c7e08bb8b65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10ec67654c963502a3f1facc39ab550c2a4816b00c1f8e173bfab32cc49a2729"
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