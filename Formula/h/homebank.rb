class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  # A mirror is used as primary URL because the official one is unstable.
  url "https://deb.debian.org/debian/pool/main/h/homebank/homebank_5.8.2.orig.tar.gz"
  mirror "http://homebank.free.fr/public/sources/homebank-5.8.2.tar.gz"
  sha256 "d42a45a2b28a1d7a7a95ef2f56539b9b6d954e1d8ba90948f509386f09737cb0"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/h/homebank/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "bf7498628165c1721cdc2e524062c4d101f3b29af873aec3df7f5c124beec229"
    sha256 arm64_ventura:  "b10d6e67cc5f61a0eb5591114a64cdf8cd105865690847a2c36a78ae06f53ec4"
    sha256 arm64_monterey: "c4661ed8dfad89b53ee714abd739567d857e8b1ff98eacd7161f9a59f5ff8b22"
    sha256 sonoma:         "10a1878b94e54aad83aec739e683ec0b7f0376110c3450af8926895a84fb72e8"
    sha256 ventura:        "402809621caeff90fad381ee692d45275ee962dcb5783c7ca7275b5c60b43b87"
    sha256 monterey:       "96b6e50db17ecab79ef1bc68fdca328dd2fb1b67f0670ecc725f2b7b2546e762"
    sha256 x86_64_linux:   "c2cf7fdf60fa262efb083abc5c6ad43fe44ded311b1b549abd20e3cffa5af961"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libofx"
  depends_on "libsoup"
  depends_on "pango"

  uses_from_macos "perl"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    if OS.linux?
      ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5"
      ENV["INTLTOOL_PERL"] = Formula["perl"].bin/"perl"
    end

    system "./configure", "--with-ofx", *std_configure_args.reject { |s| s["--disable-debug"] }
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    # homebank is a GUI application
    system bin/"homebank", "--help"
  end
end