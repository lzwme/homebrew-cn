class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.56.tar.xz"
  sha256 "51a38f35ac5b0f71defa8b9e20bf2e08563798f1cb33379a9a17726fb1e3e1b2"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]

  bottle do
    sha256                               arm64_sonoma:   "ab877bb7f4cf4c97578cdf000aad09296253aa23c92eb4806c99b0b94212fbc7"
    sha256                               arm64_ventura:  "1c020c7feb05ac13299c19e3b9f3cad99bfc524919fdd818449129c4386eb901"
    sha256                               arm64_monterey: "cc2413bea52858c9aa20d8aaa932c3dd96c3bea14fe6ac7235fe6d667291180a"
    sha256                               sonoma:         "15e9fb010a04d1c17032de58ea456e81bebd4f7684d763700631c57aacc3246c"
    sha256                               ventura:        "3d609921696fbf9bfd05652962bb2cb31d016903d877b780c8bfa4476c36bc2f"
    sha256                               monterey:       "f13a55f84d4d3533474d80f90d86126e3d1ab0e124ada3545a8daf4b299b5766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1967d0c2251845561168ab11766254ec39720d500d8a442a3cdc22e380272ce6"
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
  uses_from_macos "python" => :build
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