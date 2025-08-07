class Maxima < Formula
  desc "Computer algebra system"
  homepage "https://maxima.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.48.1-source/maxima-5.48.1.tar.gz"
  sha256 "b0916b5fb37b6eeaae400083175e68e28f80b9a1ab580c106a05448cf1c496b2"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/maxima[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c9f756377219625574fb5e55a9ee0b7f579ee4b369721acd5e1c2c7d13e780e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7f0615bfb4d74e12d4deaea80be2f9dbbcb74e003120e8de3d0f5029ff34002"
    sha256 cellar: :any_skip_relocation, sonoma:        "814828bd990cee365efb77ab78ec361090c7ec6859f2ee45efc6883f3a2f7e7f"
    sha256 cellar: :any_skip_relocation, ventura:       "1c802bebb4d39ee7cfe07bd3b4849720aa1e7f5f87c375fe7fd24bf58997bf37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c511db7fac6aa967629771d44921e2f5df7f2224fa0a420cd641d180148fe7a8"
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