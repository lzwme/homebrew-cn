class Gedit < Formula
  desc "GNOME text editor"
  homepage "https://gedit-technology.github.io/apps/gedit/"
  url "https://gitlab.gnome.org/World/gedit/gedit/-/archive/50.0/gedit-50.0.tar.bz2"
  sha256 "c2d064001b95196f046a6f9705245e3a02dc427265f4e24af9bd2d5f3cb619ee"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "a9086d4b1ae809e6a7300752c1d25a7989dba26c4534a4fd1af019b2f7e1cfff"
    sha256 arm64_sequoia: "1a84baec44eadb2a09c4ef477062f0f5d24bf02ce97f3fa828be88d318892924"
    sha256 arm64_sonoma:  "3b6e0d13f1c5975ee64c3296ac3cd8ee05a8c7c564629d007f8e8563a118d244"
    sha256 sonoma:        "d85f86c11dee8c6d5bc884e7c01b851ad7a75a548b0e1f98c2e16711f575d3cd"
    sha256 arm64_linux:   "459eedb11b562d0016437e146da72aca6499bfbcaec7e6f718c22a0cdf5d95c8"
    sha256 x86_64_linux:  "a654a11fe714360d46822a0ee23f9aea9d6c917f60128c2edc6c73c26f438fd8"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gsettings-desktop-schemas"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "libgedit-amtk"
  depends_on "libgedit-gfls"
  depends_on "libgedit-gtksourceview"
  depends_on "libgedit-tepl"
  depends_on "libpeas@1"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
    depends_on "gtk-mac-integration"
  end

  resource "libgd" do
    url "https://gitlab.gnome.org/GNOME/libgd/-/archive/c7c7ff4e05d3fe82854219091cf116cce6b19de0.tar.bz2"
    version "c7c7ff4e05d3fe82854219091cf116cce6b19de0"
    sha256 "343abb090461d011dfb1bce5b5da1dfbc9f6c7b6b3223a1b322adb33675212c1"

    livecheck do
      url "https://gitlab.gnome.org/api/v4/projects/World%2Fgedit%2Fgedit/repository/files/subprojects%2Flibgd?ref=#{LATEST_VERSION}"
      strategy :json do |json|
        json["blob_id"]
      end
    end
  end

  def install
    resource("libgd").stage buildpath/"subprojects/libgd"

    ENV["DESTDIR"] = "/"
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.append_to_cflags "-Wno-implicit-function-declaration"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/gedit" if OS.linux?

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    system Formula["gtk+3"].opt_bin/"gtk3-update-icon-cache", "-qtf", HOMEBREW_PREFIX/"share/icons/hicolor"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig" if OS.mac?
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libpeas@1"].opt_lib/"pkgconfig"

    # main executable test
    system bin/"gedit", "--version"
    # API test
    (testpath/"test.c").write <<~C
      #include <gedit/gedit-debug.h>

      int main(int argc, char *argv[]) {
        gedit_debug_init();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gedit").chomp.split
    flags << "-Wl,-rpath,#{lib}/gedit" if OS.linux?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end