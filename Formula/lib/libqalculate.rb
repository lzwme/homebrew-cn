class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https:qalculate.github.io"
  url "https:github.comQalculatelibqalculatereleasesdownloadv5.1.0libqalculate-5.1.0.tar.gz"
  sha256 "eead87ee0dbd8f11b7235ea81fe5bc308e5065aa8081dae9ac607df11fe5e4a7"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_sonoma:   "1e3a14436ab2d11836781d91419318c5dd0f924e46b2c5d9eb375cd1093124f7"
    sha256                               arm64_ventura:  "47bb0f28b6da89750535f00b8cc96b4d74eba1892e9bd3a5f2792e78fae36fe3"
    sha256                               arm64_monterey: "f3423da1c4d794aaabe73de13c91c5a52779c94f18e61307cafb8d1fac5b883e"
    sha256                               sonoma:         "e465ebdc2a480175195cb4a2f66cb408d58eda08dc09cba604e63b0490bca956"
    sha256                               ventura:        "c0885a2687a65f8b508841d2a5f7caf3fa9c44872cfa80ac8ea040e65997ee01"
    sha256                               monterey:       "fe35f8b3bec5c751cbdefb7615a65658cefbceaa8ff67fde59bfdf1a4322ab36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8ae34a2365de14ba36ff17db27ae17e8cca9e94ad783a5a0a4996f17375fcaa"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "mpfr"
  depends_on "readline"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec"libperl5" unless OS.mac?
    ENV.cxx11
    system ".configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-icu",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}qalc", "-nocurrencies", "(2+2)4 hours to minutes"
  end
end