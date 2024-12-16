class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https:qalculate.github.io"
  url "https:github.comQalculateqalculate-gtkreleasesdownloadv5.4.0qalculate-gtk-5.4.0.tar.gz"
  sha256 "9a112b3bcb348834dff631fa5d8a55f36b0e4caf5d992c21e4b1a72879611331"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:  "03c3c0964c9c4229530387adf2a2b4412b0f16cd5297ca55dd2f4d12bceeb164"
    sha256 arm64_ventura: "b144912b6e1b8b8dcc01a4a165432e5986574ac3f043bb89dde6c5257ac7a8e3"
    sha256 sonoma:        "3e91888ac73c35a9aa95551229745ca2492af60772a4f0510893628a24d4ad93"
    sha256 ventura:       "1c4e703dd69910f1669ef041776c0c2988e584be3f624185abb61ac388ab0ae3"
    sha256 x86_64_linux:  "ecc5af9871586dcbfd3edda42e683dcee528a81b6a520b5964246272ae601c1c"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libqalculate"
  depends_on "pango"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec"libperl5" unless OS.mac?

    system ".configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin"qalculate-gtk", "-v"
  end
end