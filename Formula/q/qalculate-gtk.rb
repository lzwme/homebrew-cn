class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://ghfast.top/https://github.com/Qalculate/qalculate-gtk/releases/download/v5.8.0/qalculate-gtk-5.8.0.tar.gz"
  sha256 "fdd74cbf011d5ff88219489033ec207d856aa116d3e16b729ccdbea9277a5d41"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "e7876216e6e2c07a9ba62858b766f0c48fef7a194ae976ac9b42440727540f00"
    sha256 arm64_sequoia: "fee2f5ead53ab3444e6e7aaa7da8d8cf39add5ef9d5e262ea99a71ca669640de"
    sha256 arm64_sonoma:  "fdb25842be0c0934181615e3ad5814eb38a924dacd16f567e46f670c77a705af"
    sha256 sonoma:        "a8b065c1dd1747f199195780180faffd099f599799d3e201a1ffa7079879526f"
    sha256 x86_64_linux:  "b1f03d76dd9095d569e0e519025573c8ad75ffcb02196ad3bfc76c51693b8651"
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
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"qalculate-gtk", "-v"
  end
end