class Gtk4 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk/4.18/gtk-4.18.3.tar.xz"
  sha256 "081e1bc0b17db41a935af8d1f6f090fb1988936c42ff734d149f3d004119f8bb"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/gtk[._-](4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "4582d53cc88eb5c838a1429ae26440c124f28d14c767fdc8d5c4f1de10a14a21"
    sha256 arm64_sonoma:  "1a1f05fe47c84b6cb4a19914abeeddf6742cc5e905f33b2c5eb47b2bc21a0866"
    sha256 arm64_ventura: "08958cf7806d1592081cf6f188136545ad131650edd498e333ceb52e85b3a259"
    sha256 sonoma:        "3413f81e92aebc9717e3fcda96041cb6929094a36df695495e7763dbebb81a7a"
    sha256 ventura:       "c3ce8fe4f6bb1d766b19ef2672e50b3127ef6c23f98cc0497b286d828512f217"
    sha256 arm64_linux:   "cbe13d9a5a47a8be382c0640e1a7cbf6d6b01d998c8951cfb133baf87d97129f"
    sha256 x86_64_linux:  "da5b033a2a14e87585b29ca46ae3cadaff3c0857ea4e976dcf0273a68c0aff17"
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "docutils" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "sassc" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "fribidi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
  depends_on "harfbuzz"
  depends_on "hicolor-icon-theme"
  depends_on "jpeg-turbo"
  depends_on "libepoxy"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pango"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "cups"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "wayland-protocols" => :build
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxdamage"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxkbcommon"
    depends_on "libxrandr"
    depends_on "wayland"
  end

  def install
    args = %w[
      -Dbuild-examples=false
      -Dbuild-tests=false
      -Dintrospection=enabled
      -Dman-pages=true
      -Dmedia-gstreamer=disabled
      -Dvulkan=disabled
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

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system bin/"gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "#{Formula["glib"].opt_bin}/gio-querymodules", "#{HOMEBREW_PREFIX}/lib/gtk-4.0/4.0.0/printbackends"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        gtk_disable_setlocale();
        return 0;
      }
    C

    flags = shell_output("#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs gtk4").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
    # include a version check for the pkg-config files
    assert_match version.to_s, shell_output("cat #{lib}/pkgconfig/gtk4.pc").strip
  end
end