class Less < Formula
  desc "Pager program similar to more"
  homepage "https://www.greenwoodsoftware.com/less/index.html"
  url "https://www.greenwoodsoftware.com/less/less-632.tar.gz"
  sha256 "6f71b2a9178ddad8a238259032f3c9d21929846ce453af2a77fc906ccc31d4d9"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/less[._-]v?(\d+(?:\.\d+)*).+?released.+?general use/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ec148a98b3bbf400586712fb454a9fe00e0def2807277615056245c2fdf5f85e"
    sha256 cellar: :any,                 arm64_monterey: "ee29efa71f72fe4521b5b6138b1a8893667a977d79e35215325b0b9323526eae"
    sha256 cellar: :any,                 arm64_big_sur:  "2a583a15e8db2ea00ed0913dc0e6eb48f34e0fc0d741d60765a8c3529bb081b9"
    sha256 cellar: :any,                 ventura:        "cb68ae94fab35996fb22ce3f5ddfb32b1cfd6186e82f42ed8d81f22bd611ddbb"
    sha256 cellar: :any,                 monterey:       "984f1190303f16964fbc926d48035695acb02122a31030bd07a6bf9a5dc61407"
    sha256 cellar: :any,                 big_sur:        "8bf48e3ec0cb0175ac65dd84ba268266b901784b1461570ab95d86855db9e9b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e1f29c37af072642b039f56642f8b86c728cd2ea47b175c4e170add3aeb5362"
  end

  head do
    url "https://github.com/gwsw/less.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "groff" => :build
    uses_from_macos "perl" => :build
  end

  depends_on "ncurses"
  depends_on "pcre2"

  def install
    system "make", "-f", "Makefile.aut", "distfiles" if build.head?
    system "./configure", "--prefix=#{prefix}", "--with-regex=pcre2"
    system "make", "install"
  end

  test do
    system "#{bin}/lesskey", "-V"
  end
end