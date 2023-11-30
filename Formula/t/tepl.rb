class Tepl < Formula
  desc "GNOME Text Editor Product Line"
  homepage "https://gitlab.gnome.org/swilmet/tepl"
  url "https://gitlab.gnome.org/swilmet/tepl.git",
      tag:      "6.8.0",
      revision: "16ab2567257a053bd957699f89080fafd0999035"
  license "LGPL-2.1-or-later"
  revision 1
  version_scheme 1

  # https://gitlab.gnome.org/swilmet/tepl/-/blob/main/docs/more-information.md
  # Tepl follows the even/odd minor version scheme. Odd minor versions are
  # development snapshots; even minor versions are stable.
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468](?:\.\d+)*)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "904381040ea00a392676bf07a06285f804f2b264ef6abc32b0d60866ffba923b"
    sha256 arm64_ventura:  "25a9ad09ff5c6c64dd08c1cb73ff231a39c262d1a63346587d6919d13a8d6c30"
    sha256 arm64_monterey: "1f7eb850af645bab127b303f8ce2b7b2bf365c4791105d9f734cd179be35e1bd"
    sha256 sonoma:         "441359d3ae864be1e4dc8b6bbd8c25445195d1fd6b6b718095870048689313fe"
    sha256 ventura:        "9ad95345b1572244629ea1c55ffe429bd9e747eb19a0b803fcc74f7fd4debf45"
    sha256 monterey:       "0349eb6b7d5b0d1eefda927cf1919e0f5c360dd785bbb9d30834b6e1ab5d04a5"
    sha256 x86_64_linux:   "73f88e00cbe024ae362ea760159576d070bd065d4025366a7bdf77a7c2f58fca"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "libgedit-amtk"
  depends_on "libgedit-gtksourceview"
  depends_on "uchardet"

  def install
    system "meson", "setup", "build", "-Dgtk_doc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tepl/tepl.h>

      int main(int argc, char *argv[]) {
        GType type = tepl_file_get_type();
        return 0;
      }
    EOS
    ENV.libxml2
    atk = Formula["atk"]
    amtk = Formula["libgedit-amtk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx3 = Formula["gtk+3"]
    gtksourceview = Formula["libgedit-gtksourceview"]
    harfbuzz = Formula["harfbuzz"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pcre = Formula["pcre"]
    pixman = Formula["pixman"]
    uchardet = Formula["uchardet"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{amtk.opt_include}/libgedit-amtk-5
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtksourceview.opt_include}/libgedit-gtksourceview-300
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/tepl-#{version.major}
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pcre.opt_include}
      -I#{pixman.opt_include}/pixman-1
      -I#{uchardet.opt_include}/uchardet
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{amtk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtksourceview.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lgedit-amtk-5
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -ltepl-6
      -lgtk-3
      -lgedit-gtksourceview-300
      -lpango-1.0
      -lpangocairo-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end