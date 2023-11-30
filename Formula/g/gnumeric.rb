class Gnumeric < Formula
  desc "GNOME Spreadsheet Application"
  homepage "https://projects.gnome.org/gnumeric/"
  url "https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.56.tar.xz"
  sha256 "51a38f35ac5b0f71defa8b9e20bf2e08563798f1cb33379a9a17726fb1e3e1b2"
  license any_of: ["GPL-3.0-only", "GPL-2.0-only"]
  revision 1

  bottle do
    sha256                               arm64_sonoma:   "4654930a19b5295b3808857cf1985b778999b4d04a9dfd3a58cdf253988bf5c1"
    sha256                               arm64_ventura:  "1a43c1ca977f60182710adee735cdc107321326e9f258586a0e14ee3fba6161e"
    sha256                               arm64_monterey: "4530fbd65dd79250711dcae5ed15edc7c3338892aeb4e73365a14a95fb74bf56"
    sha256                               sonoma:         "afcc4c8fae9d15ab06ff3e103bb212fffe54a48f3b5cc473778b5e48c37e2578"
    sha256                               ventura:        "bc3ca8c247541147ad1b019ad370a43cd118b45f5100491b62e35490facdc3dd"
    sha256                               monterey:       "d5013e28b3a916249d65bbe7e1eca52102e0c98eab41593621f8a22f259a2c45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59e18dcd5e4cb826854ae189716f058f1a91dd2fb2a3cd60430a02e614d9765a"
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

  # Fix build with libxml2 2.12. Remove if upstream PR is merged and in release.
  # PR ref: https://gitlab.gnome.org/GNOME/gnumeric/-/merge_requests/32
  patch do
    url "https://gitlab.gnome.org/GNOME/gnumeric/-/commit/a95622e5da645481d87d8d4fc6b339123cce0498.diff"
    sha256 "892b0ec2a566846c1545638336cdd4157bf9114d98abb3afbda074e179c0fa2a"
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