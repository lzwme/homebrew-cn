class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.55.tar.xz"
  sha256 "c69a09cd190b622acca476bbc3d4c03d68d7ccf59bba61bf036ce60885f9fb65"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]
  revision 1

  bottle do
    sha256                               arm64_sonoma:   "dd42aa96ff8b79898c9f90647b7747529d2a67396c12d01a2d94a8d4200b340e"
    sha256                               arm64_ventura:  "83ab915e64347ea4c3b3cf55bc82f48b5c23c504dd5b844c55013b87d1f249dc"
    sha256                               arm64_monterey: "88cfead4de113e54b1c24834df19440088cd7453cd435bd75f43c5dcc772490d"
    sha256                               sonoma:         "6f1ed50227be68a9af440d39c3d7ec2758ce18664e9c47d8e9f3c986b86ba3fe"
    sha256                               ventura:        "ff12af5b542cd23f0fc62a3cd07090ee289d229abb83ace465485e0f84ee2655"
    sha256                               monterey:       "6a5163689240a62d309898b16d7b1c4755af057aa5aa93c7db51cf7e7da78d41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "120582c44f3d7c75a37124a87ab8521600157c5cebd1e0eba4f2d428b49d5ead"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "goffice"
  depends_on "gtk+3"
  depends_on "libgsf"
  depends_on "libxml2"
  depends_on "pango"

  uses_from_macos "bison" => :build
  uses_from_macos "perl"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "perl-xml-parser"
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].opt_libexec/"lib/perl5" unless OS.mac?

    # ensures that the files remain within the keg
    inreplace "component/Makefile.in",
              "GOFFICE_PLUGINS_DIR = @GOFFICE_PLUGINS_DIR@",
              "GOFFICE_PLUGINS_DIR = @libdir@/goffice/@GOFFICE_API_VER@/plugins/gnumeric"

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-schemas-compile"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system bin/"gnumeric", "--version"
  end
end