class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.47.0-source/maxima-5.47.0.tar.gz"
  sha256 "9104021b24fd53e8c03a983509cb42e937a925e8c0c85c335d7709a14fd40f7a"
  license "GPL-2.0-only"
  revision 19

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5a32f8f571ca128e2eba9caae15ae3e1957a8232b5330c68a1d80616e4cc067"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb4f1e647cbc0fbc527bb02e39622d2e594d69115ef6e9de1b6633aa178bbac8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8cddbf17ba4e85ac9b2f71d2b762e725ef1a53056fbe582541a6494cca68fe2"
    sha256 cellar: :any_skip_relocation, ventura:       "de408eadffeabfd0a511bf6c48f5ba1097a6344066f87ec46c96d1ec3d292ba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7de7fd7d58068b3cb4b93dfdcf088d74c03dbb4177fe66142d34efb8c1ec9ce4"
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