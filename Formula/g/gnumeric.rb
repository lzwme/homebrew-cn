class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.59.tar.xz"
  sha256 "cb3750b176d641f9423df721b831658c829557552f8887fedf8a53d907eceb51"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]
  revision 2

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "4ac7dea83b2eb4d74f31b8e812e25904af3af14a955332571741b95107a38ef0"
    sha256                               arm64_sequoia: "adfe58cdf7d291a9d90890e50c16efeaab5d3a7c564b70b58d11e929ceb33a04"
    sha256                               arm64_sonoma:  "7a50680bdf46974da58a8314260e0c94717c0cd0625d20075dd0ccfdd2fff087"
    sha256                               sonoma:        "01f4fa7b9128bbb680186ea431d5015a60db896af1ba836dcf4d0d17add25bea"
    sha256                               arm64_linux:   "a0420280151e0c98a886dea79302d9aa1034664c1bbb749ed94436eb836aa1a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d89781b7145143445516f07cdaa88513abdedad4b1f287da2feee9669b91961a"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "goffice"
  depends_on "gtk+3"
  depends_on "libgsf"
  depends_on "libxml2"
  depends_on "pango"

  uses_from_macos "bison" => :build
  uses_from_macos "python" => :build
  uses_from_macos "perl"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
    depends_on "zlib-ng-compat"
  end

  def install
    # ensures that the files remain within the keg
    inreplace "component/Makefile.in",
              "GOFFICE_PLUGINS_DIR = @GOFFICE_PLUGINS_DIR@",
              "GOFFICE_PLUGINS_DIR = @libdir@/goffice/@GOFFICE_API_VER@/plugins/gnumeric"

    system "./configure", "--disable-schemas-compile",
                          "--disable-silent-rules",
                          *std_configure_args
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system bin/"gnumeric", "--version"
  end
end