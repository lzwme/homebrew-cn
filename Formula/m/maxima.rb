class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.49.0-source/maxima-5.49.0.tar.gz"
  sha256 "6d401a4aa307cd3a5a9cadca4fa96c4ef0e24ff95a18bb6a8f803e3d2114adee"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f62bd27521c79e7d3480d856a5ab64060775e8faa7f5a0b5b15fe33a90f0df9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd33578fd89da385965f3a5a644fe608254bcd741eb03e9f80184b717cc8e6ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2a9624b79539b1b9de1d0d5d330f8b74c441f4b3dcb4f9b061ef8c0b84525f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae18b085173a31d6b54045eb9b0faa4e6744014f1a33ea38f50e84f27fecad09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d56f266a366a6732a75e8ec43c9a80137a211a074fa2021243a49fb733c28560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e11010620c1524af12243be76116f4dbac00a243e97dc5a41f21342b8685bdba"
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
    system "./configure", "--enable-gettext",
                          "--enable-sbcl",
                          "--with-emacs-prefix=#{elisp}",
                          "--with-sbcl=#{Formula["sbcl"].opt_bin}/sbcl",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"maxima", "--batch-string=run_testsuite(); quit();"
  end
end