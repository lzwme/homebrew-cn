class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https:qalculate.github.io"
  url "https:github.comQalculatelibqalculatereleasesdownloadv5.4.0libqalculate-5.4.0.tar.gz"
  sha256 "1fe956877ff1bbb1f4b470c41cdf3d971cebbeda6a35e92282f0eea5193ac343"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_sonoma:  "a1e22572437ada78996832232bd2e82af47074263414efc0512a69b62cbb1ced"
    sha256                               arm64_ventura: "8ef6eb8153508170ce09c5b9fc705ed99a87f875591c2776502dd9837905c71c"
    sha256                               sonoma:        "36d7d41180e2395759660c1bf61b6d12ed4882c74eabdc3175734ca94bbf9b88"
    sha256                               ventura:       "31a8d6f178afad7dc9b775e7475d1b6078248d7d6cfb60e6b228f652248d242c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0eb72acac6384ae46d96ebf55fb95aed0d0dc601dad91b461a0a33de0bb09c41"
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