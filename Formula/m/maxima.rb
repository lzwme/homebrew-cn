class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.47.0-source/maxima-5.47.0.tar.gz"
  sha256 "9104021b24fd53e8c03a983509cb42e937a925e8c0c85c335d7709a14fd40f7a"
  license "GPL-2.0-only"
  revision 16

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2a5e17d2d82f5a9eea501efeec7511934b8407fe19092f61deb49b0b3bc4f2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1dab671ad55c690f4d3d6821b6820296097be7d7aac2b19bc1b22cdddf0ebefc"
    sha256 cellar: :any_skip_relocation, sonoma:        "76b90c09755092b67179e016704f6fd8ac2e279c2e836da05c05aeea9a3fccd4"
    sha256 cellar: :any_skip_relocation, ventura:       "8e6f91908ac801cf9058c4bd010634be590bc306d2723427201b045669536cfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a69b4d346a41c592ad9286b822ab27a847444c5a5962cbe3992cd7957bff007"
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