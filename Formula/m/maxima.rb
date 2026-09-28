class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.50.0-source/maxima-5.50.0.tar.gz"
  sha256 "0bc4b5e11fe153ef20b24a3a816b668ece5378cc738fa24ca426b62fd6d8fc37"
  license "GPL-2.0-only"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "579a3993261da5d3d3ec137cffef18a41fd5d0ddeab3284673bc3f43aee11970"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "33e3ccdfc1dc37def1ed866c576195691287176bb017acc818d4a929890b0e2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1f02c8c360061c0f413ecb2926771647761e68e68c4b3c583fda27d12cc1095d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "de4465b3b19e27a5539560dc31f87b38ca40c845ed022ee9fac6d8a484dd85cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5e4565de592c01cc6346b47be9942d5d3c2c14fe4086ea02b89345b7a592d873"
  end

  depends_on "gawk" => :build
  depends_on "texinfo" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "rlwrap"
  depends_on "sbcl"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gnu-sed" => :build
  end

  def install
    ENV["LANG"] = "C" # per build instructions
    system "./configure", "--enable-gettext",
                          "--enable-sbcl",
                          "--with-emacs-prefix=#{elisp}",
                          "--with-sbcl=#{formula_opt_bin("sbcl")}/sbcl",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"maxima", "--batch-string=run_testsuite(); quit();"
  end
end