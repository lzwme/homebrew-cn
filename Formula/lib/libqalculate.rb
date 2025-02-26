class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https:qalculate.github.io"
  url "https:github.comQalculatelibqalculatereleasesdownloadv5.5.1libqalculate-5.5.1.tar.gz"
  sha256 "52fc85327b20cf56fa3eeba8f2ca86779f30baf6f8abcede117710801fe55032"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_sonoma:  "8a80ea5af0bdf2884323a450186914ebd646fea6aa4fb5469259b4a9973eea07"
    sha256                               arm64_ventura: "22e31c4665b47be87cec9ae3b2a9bad7bb6fb0558b4dbb77d0a9d65694f41215"
    sha256                               sonoma:        "97d2f7ac7925e5a63b8488788c9423b0dae50939c24b4e7deaefa4bede3352b3"
    sha256                               ventura:       "85e37c1cb3909a1bed2af46dba0aceabc8b1cd621502124fb50d10f18d7dc13c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e50cf179002eb5b9689e97115962320024d0605975cbdc6b57b2ac74ffa36302"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "gnuplot"
  depends_on "mpfr"
  depends_on "readline"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    ENV.cxx11
    system ".configure", "--disable-silent-rules",
                          "--without-icu",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin"qalc", "-nocurrencies", "(2+2)4 hours to minutes"
  end
end