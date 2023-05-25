class Utftex < Formula
  desc "Pretty print math in monospace fonts, using a TeX-like syntax"
  homepage "https://github.com/bartp5/libtexprintf"
  url "https://ghproxy.com/https://github.com/bartp5/libtexprintf/archive/refs/tags/v1.18.tar.gz"
  sha256 "ff39c33629ae9bc6f8782b9fdfa14a240a75ee3a3bf80d02f95bf31c522f9e31"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "af1e18aa043166b7bc501d7df5339acbb34172e08e8bd0f268c815cb22bf21f4"
    sha256 cellar: :any,                 arm64_monterey: "8e9f5976d421de534701d624b895104e3a30c6084bba822c57cf57c0f73d3a1b"
    sha256 cellar: :any,                 arm64_big_sur:  "2e948b5fdd3bb115fd246de90cac5cccb68e73c65ea36a854dac6736582a19db"
    sha256 cellar: :any,                 ventura:        "11e61d5f0a3430fa190488d403606f7ca80a43ca8781dd8899c271338d1835c5"
    sha256 cellar: :any,                 monterey:       "ab61d9f5c135fea6412d46690cb01b6e4a9b65faa4e07aab129f7c31414d5201"
    sha256 cellar: :any,                 big_sur:        "398f48bcc28daa596e91c5a4cc27d3702de79ad16ab72ad5667dbae6260e1a84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5ba1f8f606e664f5c662287c4ffdf5c829cd5f81c489d225959046fe9d2f767"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # Fixes race condition in Makefile
  # Remove in next release
  patch do
    url "https://github.com/bartp5/libtexprintf/commit/65fb91ab307f3185278fca354f21f4c282cc7154.patch?full_index=1"
    sha256 "23d67a77fc27ecfb7c9c600db2eeb58eb78fe0ef1d23e00415e9cc08fdd1620a"
  end

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"utftex", "\\left(\\frac{hello}{world}\\right)"
  end
end