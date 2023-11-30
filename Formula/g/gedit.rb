class Gedit < Formula
  desc "GNOME text editor"
  homepage "https://wiki.gnome.org/Apps/Gedit"
  url "https://download.gnome.org/sources/gedit/46/gedit-46.1.tar.xz"
  sha256 "a1a6e37f041765dff7227a1f5578b6f49faaf016b1e17e869caf5bfb94c6aa4e"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "3dc00cee81ce4db3e3d62fc48f48ed23f074eb55e3d767a2594a5630ba34a708"
    sha256 arm64_ventura:  "12cfbae2966fdde44d786f39497b69416b992f2fb2c5ddefac80b7ca7b8e5c6c"
    sha256 arm64_monterey: "d70cc384ceb71f0044a89d4ce63bad6636b4b2cbe8b3e635bcc7dc082d4c250b"
    sha256 sonoma:         "16550a2071d4569b67761a1e0f046dc5dc8e6a81e1f9f984a6f661e255bc7742"
    sha256 ventura:        "2fe8a8789a93f1cfacd424309c1a8c790c29f47345236e8c6649a55fd118ae8a"
    sha256 monterey:       "ebf405597d4719e974f378b2ae032119d4f73ca0f826ec263858ab4fa26da9bd"
    sha256 x86_64_linux:   "cf98197954d5156b7fe90ea20ef7ddfd1c5548b6e83e792d13925bdfc5f5d405"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "docbook-xsl" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gsettings-desktop-schemas"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "libgedit-amtk"
  depends_on "libgedit-gtksourceview"
  depends_on "libpeas"
  depends_on "libsoup"
  depends_on "libxml2"
  depends_on "pango"
  depends_on "tepl"

  def install
    ENV["DESTDIR"] = "/"
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
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

    # main executable test
    system bin/"gedit", "--version"
    # API test
    (testpath/"test.c").write <<~EOS
      #include <gedit/gedit-debug.h>

      int main(int argc, char *argv[]) {
        gedit_debug_init();
        return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs gedit").chomp.split
    flags << "-Wl,-rpath,#{lib}/gedit" if OS.linux?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end