class Gedit < Formula
  desc "GNOME text editor"
  homepage "https://wiki.gnome.org/Apps/Gedit"
  url "https://download.gnome.org/sources/gedit/46/gedit-46.0.tar.xz"
  sha256 "2ca1be052902cf05b1f3d389d12e3cc8cb906740c10c9bde3cb8af6db58f655f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "d49f8def6f60ae80e863c314f929740a7ade2f0044d02b59210cbf7e91b82d12"
    sha256 arm64_monterey: "431cf737ae2c7190028c134424659df02561a9edb2209f14cb1467ceb1a66818"
    sha256 arm64_big_sur:  "b9d339a2cda8c0b06e119a9b07738ddc8a2a180e2d614d03a0af7a42b3515239"
    sha256 ventura:        "02cb9152f7888d9f41e415b3f79b3b508bf1e073307c12e15992846e3dce449c"
    sha256 monterey:       "092f8a1ceea8e165f5ca81ec05ec3fe92d8721876938a15859af13b8965e2c09"
    sha256 big_sur:        "afcf433c246f23d77a3945d749824c05563f4bf2611878ff788bc45b4a3f48bf"
    sha256 x86_64_linux:   "f74b0d3d8e9b1efb0e22c5fa92c49a2adce96fd5bbbc22ac60a65a2211d0c9da"
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
  depends_on "atk"
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

  # Fixes `git submodule` failure.
  # Remove on next release.
  patch do
    url "https://gitlab.gnome.org/GNOME/gedit/-/commit/02b0a3ab1486406c1fb300c1bdee7060946c3d66.diff"
    sha256 "4cb4cb888964248cf9507ad58e4eaef99267b446f6f8d06cd2d82c8d32818bd3"
  end

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