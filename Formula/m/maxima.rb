class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.47.0-source/maxima-5.47.0.tar.gz"
  sha256 "9104021b24fd53e8c03a983509cb42e937a925e8c0c85c335d7709a14fd40f7a"
  license "GPL-2.0-only"
  revision 13

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27547435a5946bfd24894f45e918ea72f93cc96972b3c883cee2f201bb05737b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf44456e3ee19d48c66d252122ae56f2446f1075c0087a03dd82c62c81230e69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d25115b1fff7fece24f30563f3c663da7db54ca05d8c5b45da570d51236963fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed79594d0832e6d7e7610c65db2caba4c72c241b64a034b862fecff54921f7ab"
    sha256 cellar: :any_skip_relocation, ventura:        "f721524a9c09dc6457960de1c802d062aece44ecadda8f22f85b56bd3feea23e"
    sha256 cellar: :any_skip_relocation, monterey:       "b3168150ee0b2289671049089e54551bf16497c67084d0fa5939546b9fea0eb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df28315c027ab0783ceae7e3060f2c2796e9365c104caa7d3f50d08d763f40dd"
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