class Gitg < Formula
  desc "GNOME GUI client to view git repositories"
  homepage "https://wiki.gnome.org/Apps/Gitg"
  url "https://download.gnome.org/sources/gitg/44/gitg-44.tar.xz"
  sha256 "342a31684dab9671cd341bd3e3ce665adcee0460c2a081ddc493cdbc03132530"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/gitg[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "6a3792e1a8fb1f1beab17739854b9fe878d63bd0570ffda93de931cc22c0bc4a"
    sha256 arm64_ventura:  "fc2f0b0edfc46fe32b3f1aa1cfc6895d6b5b6a6d84658caee6921eee63479923"
    sha256 arm64_monterey: "7666684bd3a772f45c8c60f361220dd9cd89df7aa1288f1675d22409e4e1347b"
    sha256 sonoma:         "a98edb3969a3d3bd77beec4870bd82c25ca007e4ec8fe22e5f6e44b55968db15"
    sha256 ventura:        "b75c52ee821485af5cf2b4eb0792ffb56cf69c23357e2749fcb85d3ef9bb8181"
    sha256 monterey:       "e3d1aadf82552d4223700479fbfef5ae1fc86998e375916e1b8f6b27fd52f15d"
    sha256 x86_64_linux:   "60607bcd2f70853f3d703515b8e4d85c65446777bfc4b90dcfaa841ea5db4b2e"
  end

  depends_on "gettext" => :build # for `msgfmt`
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gobject-introspection"
  depends_on "gpgme"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "libdazzle"
  depends_on "libgee"
  depends_on "libgit2"
  depends_on "libgit2-glib"
  depends_on "libhandy"
  depends_on "libpeas"
  depends_on "libsecret"

  def install
    # Work-around for build issue with Xcode 15.3: https://gitlab.gnome.org/GNOME/gitg/-/issues/465
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", "-Dpython=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # test executable
    # Disable this part of test on Linux because display is not available.
    assert_match version.to_s, shell_output("#{bin}/gitg --version") if OS.mac?
    # test API
    (testpath/"test.c").write <<~EOS
      #include <libgitg/libgitg.h>

      int main(int argc, char *argv[]) {
        GType gtype = gitg_stage_status_file_get_type();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gobject_introspection = Formula["gobject-introspection"]
    gpgme = Formula["gpgme"]
    gtkx3 = Formula["gtk+3"]
    harfbuzz = Formula["harfbuzz"]
    libepoxy = Formula["libepoxy"]
    libffi = Formula["libffi"]
    libgee = Formula["libgee"]
    libgit2 = Formula["libgit2"]
    libgit2_glib = Formula["libgit2-glib"]
    libhandy = Formula["libhandy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gobject_introspection.opt_include}/gobject-introspection-1.0
      -I#{gpgme.opt_include}
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/libgitg-1.0
      -I#{libepoxy.opt_include}
      -I#{libgee.opt_include}/gee-0.8
      -I#{libffi.opt_lib}/libffi-3.0.13/include
      -I#{libgit2}/include
      -I#{libgit2_glib.opt_include}/libgit2-glib-1.0
      -I#{libhandy.opt_include}/libhandy-1
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -DGIT_SSH=1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gobject_introspection.opt_lib}
      -L#{gpgme.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{libgee.opt_lib}
      -L#{libgit2.opt_lib}
      -L#{libgit2_glib.opt_lib}
      -L#{libhandy.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lgirepository-1.0
      -lgit2
      -lgit2-glib-1.0
      -lgitg-1.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lgpgme
      -lgthread-2.0
      -lgtk-3
      -lhandy-1
      -lpango-1.0
      -lpangocairo-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end