class Gtk4 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk/4.10/gtk-4.10.3.tar.xz"
  sha256 "4545441ad79e377eb6e0a705026dc7a46886e46a1b034db40912909da801cea9"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/gtk[._-](4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "2c9323d79435b72d546a851e5d08cc66bdaf073894507ebabb1b64241361b927"
    sha256 arm64_monterey: "eff612ea8223f41deb80d7e5a287f97ac53a1c84938585f0fcc1e00a90ad635a"
    sha256 arm64_big_sur:  "f971491ac01d156b4f1efea4056e333d7f63a84ce713882bab289f26a9e59822"
    sha256 ventura:        "74d693a836f1531ba21bf1f84d000aca8285c93f029b17622619224af852c9b2"
    sha256 monterey:       "d86f1ea6376f31b6c7e543d086950294555deaba4fb88af8988a08c31bc16886"
    sha256 big_sur:        "6bad61626162fd127d32364ae9bd1a89e5064513ffc8a86c928b6591949eeaed"
    sha256 x86_64_linux:   "1a5f658223722c2f83ff5d15f332965722858eafd030b6a9287731d5da924dfc"
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "docutils" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "sassc" => :build
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
  depends_on "hicolor-icon-theme"
  depends_on "jpeg-turbo"
  depends_on "libepoxy"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pango"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "cups"

  on_linux do
    depends_on "libxcursor"
    depends_on "libxkbcommon"
  end

  def install
    args = %w[
      -Dgtk_doc=false
      -Dman-pages=true
      -Dintrospection=enabled
      -Dbuild-examples=false
      -Dbuild-tests=false
      -Dmedia-gstreamer=disabled
    ]

    if OS.mac?
      args << "-Dx11-backend=false"
      args << "-Dmacos-backend=true"
      args << "-Dprint-cups=disabled" if MacOS.version <= :mojave
    end

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # Disable asserts and cast checks explicitly
    ENV.append "CPPFLAGS", "-DG_DISABLE_ASSERT -DG_DISABLE_CAST_CHECKS"

    system "meson", *std_meson_args, "build", *args
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system bin/"gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "#{Formula["glib"].opt_bin}/gio-querymodules", "#{HOMEBREW_PREFIX}/lib/gtk-4.0/4.0.0/printbackends"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        gtk_disable_setlocale();
        return 0;
      }
    EOS
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["jpeg-turbo"].opt_lib/"pkgconfig"
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs gtk4").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
    # include a version check for the pkg-config files
    assert_match version.to_s, shell_output("cat #{lib}/pkgconfig/gtk4.pc").strip
  end
end