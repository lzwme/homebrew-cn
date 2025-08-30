class Gtkx3 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk/3.24/gtk-3.24.49.tar.xz"
  sha256 "5ea52c6a28f0e5ecf2e9a3c2facbb30d040b73871fcd5f33cd1317e9018a146e"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/gtk\+?[._-](3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "347b3e3e336edcb0c2b8aa5ad7efb0b1415ac65f67466275b05c2733abda16a0"
    sha256 arm64_sonoma:  "ff498b6d04d99c1e2ec972b341e7bcae197727b2237e0b8f072e7a7020514fbc"
    sha256 arm64_ventura: "3aa5ac2b8551cbf9eaf30713a8ab7907b82a904409d0516f303bbfd29256a946"
    sha256 sonoma:        "2cacc04efe921c90b249335794eba802bad712bcca12232436be427d5bd0e65d"
    sha256 ventura:       "854b5cdf5279ed10814059c24aad561a15d79374a340f11ffa63944f59e27e26"
    sha256 arm64_linux:   "069191f41fb887645e43dd3d534b6291914c37e5c7c6c27bc0cbac23834bea3b"
    sha256 x86_64_linux:  "b761f99380035f49c85f39523bde4be98baa8bda72d71d60273d0c4d8ce78774"
  end

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "fribidi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gsettings-desktop-schemas"
  depends_on "harfbuzz"
  depends_on "hicolor-icon-theme"
  depends_on "libepoxy"
  depends_on "pango"

  uses_from_macos "libxslt" => :build # for xsltproc

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "cmake" => :build

    depends_on "fontconfig"
    depends_on "iso-codes"
    depends_on "libx11"
    depends_on "libxdamage"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxkbcommon"
    depends_on "libxrandr"
    depends_on "wayland"
    depends_on "wayland-protocols"
    depends_on "xorgproto"
  end

  def install
    args = %w[
      -Dgtk_doc=false
      -Dman=true
      -Dintrospection=true
    ]

    if OS.mac?
      args << "-Dquartz_backend=true"
      args << "-Dx11_backend=false"
    end

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    bin.install_symlink bin/"gtk-update-icon-cache" => "gtk3-update-icon-cache"
    man1.install_symlink man1/"gtk-update-icon-cache.1" => "gtk3-update-icon-cache.1"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system bin/"gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system bin/"gtk-query-immodules-3.0 > #{HOMEBREW_PREFIX}/lib/gtk-3.0/3.0.0/immodules.cache"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        gtk_disable_setlocale();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gtk+-3.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
    # include a version check for the pkg-config files
    assert_match version.to_s, shell_output("cat #{lib}/pkgconfig/gtk+-3.0.pc").strip
  end
end