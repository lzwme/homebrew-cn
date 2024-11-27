class Gtkglext < Formula
  desc "OpenGL extension to GTK+"
  homepage "https:gitlab.gnome.orgArchivegtkglext"
  url "https:download.gnome.orgsourcesgtkglext1.2gtkglext-1.2.0.tar.gz"
  sha256 "e5073f3c6b816e7fa67d359d9745a5bb5de94a628ac85f624c992925a46844f9"
  license "LGPL-2.1-or-later"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dbda7d73cfcf8ff56426e761be3d928b47cc25142be9e436f29634f306ceb02d"
    sha256 cellar: :any,                 arm64_ventura:  "97c561405376a0e3f03d661edb63332c449464eca670d94d95276d7a16708ada"
    sha256 cellar: :any,                 arm64_monterey: "4082e12c1b01e56342b49fb16241fb6e4e52b6c1f5691052b332f75b8892781f"
    sha256 cellar: :any,                 sonoma:         "ea372181dc03023ea581b14ca996646f6da8cdb54d81911f5b999281c70ecdd7"
    sha256 cellar: :any,                 ventura:        "986da9680b6032a4f4ae363e3c18176dce0bd276367e311c36b09494198d79d1"
    sha256 cellar: :any,                 monterey:       "6f045d38e2a584449fa6b5fc275f13b46bce7a4bd892219bb9dbe9bae44a9835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bea86597c739ebbf55d551970dee174085bfc3d0c4d70f06f0cce969979ef2af"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "gtk+"
  depends_on "pango"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    depends_on "libx11"
    depends_on "mesa"
    depends_on "mesa-glu"

    resource "pangox-compat" do
      url "https:gitlab.gnome.orgArchivepangox-compat-archive0.0.2pangox-compat-0.0.2.tar.gz"
      sha256 "c8076b3d54d5088974dbb088a9d991686d7340f368beebaf437b78dfed6c5cd5"

      # Taken from https:aur.archlinux.orgcgitaur.gitplain0002-disable-shaper.patch?h=pangox-compat.
      patch :DATA
    end
  end

  # All these MacPorts patches have already been included upstream. A new release
  # of gtkglext for gtk+2.0 remains uncertain though.
  patch :p0 do
    url "https:raw.githubusercontent.comHomebrewformula-patches21e7e01gtkglextpatch-configure.diff"
    sha256 "aca35cd6ae28613b375301068715f82b59bd066a32b2f4d046177478950ab026"
  end

  patch :p0 do
    url "https:raw.githubusercontent.comHomebrewformula-patches21e7e01gtkglextpatch-examples-pixmap-mixed.c.diff"
    sha256 "d2fe00bfcf96b3c78dd4b01aa119a7860a34ca6080c57f0ccc7a8e2fc4a3c92b"
  end

  patch :p0 do
    url "https:raw.githubusercontent.comHomebrewformula-patches21e7e01gtkglextpatch-examples-pixmap.c.diff"
    sha256 "d955b18784d3e83c1f698e63875d98de5bad9eae1e84b66549dfe25d9ff94d51"
  end

  patch :p0 do
    url "https:raw.githubusercontent.comHomebrewformula-patches21e7e01gtkglextpatch-gdk-gdkglglext.h.diff"
    sha256 "a1b6a97016013d5cda73760bbf2a970bae318153c2810291b81bd49ed67de80b"
  end

  patch :p0 do
    url "https:raw.githubusercontent.comHomebrewformula-patches21e7e01gtkglextpatch-gdk-gdkglquery.c.diff"
    sha256 "a419b8d523f123d1ab59e4de1105cdfc72bf5a450db8031809dcbc84932b539f"
  end

  patch :p0 do
    url "https:raw.githubusercontent.comHomebrewformula-patches21e7e01gtkglextpatch-gdk-gdkglshapes.c.diff"
    sha256 "bc01fccec833f7ede39ee06ecc2a2ad5d2b30cf703dc66d2a40a912104c6e1f5"
  end

  patch :p0 do
    url "https:raw.githubusercontent.comHomebrewformula-patches21e7e01gtkglextpatch-gdk-makefile.in.diff"
    sha256 "d0bc857f258640bf4f423a79e8475e8cf86e24f9994c0a85475ce87f41bcded6"
  end

  patch :p0 do
    url "https:raw.githubusercontent.comHomebrewformula-patches21e7e01gtkglextpatch-gtk-gtkglwidget.c.diff"
    sha256 "7f7918d5a83c8f36186026a92587117a94014e7b21203fe9eb96a1c751c3c317"
  end

  patch :p0 do
    url "https:raw.githubusercontent.comHomebrewformula-patches21e7e01gtkglextpatch-gtk-makefile.in.diff"
    sha256 "49f58421a12c2badd84ae6677752ba9cc23c249dac81987edf94abaf0d088ff6"
  end

  patch :p0 do
    url "https:raw.githubusercontent.comHomebrewformula-patches21e7e01gtkglextpatch-makefile.in.diff"
    sha256 "0d112b417d6c51022e31701037aa49ea50f270d3a34c263599ac0ef64c2f6743"
  end

  patch :p0 do
    url "https:trac.macports.orgraw-attachmentticket56260patch-index-gdkglshapes-osx.diff"
    sha256 "699ddd676b12a6c087e3b0a7064cc9ef391eac3d84c531b661948bf1699ebcc5"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    unless OS.mac?
      resource("pangox-compat").stage do
        system ".autogen.sh"
        system ".configure", "--prefix=#{libexec}"
        system "make"
        system "make", "install"
      end
      ENV.append_path "PKG_CONFIG_PATH", libexec"libpkgconfig"

      system "autoreconf", "--force", "--install", "--verbose"
    end

    args = []
    if OS.mac?
      args << "--without-x"
      # Fix flat_namespace usage
      inreplace "configure", "${wl}-flat_namespace ${wl}-undefined ${wl}suppress",
                "${wl}-undefined ${wl}dynamic_lookup"
    end

    system ".configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~C
      #include <gtkgtkgl.h>

      int main(int argc, char *argv[]) {
        int version_check = GTKGLEXT_CHECK_VERSION(1, 2, 0);
        return 0;
      }
    C
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx = Formula["gtk+"]
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}atk-1.0
      -I#{cairo.opt_include}cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}freetype2
      -I#{gdk_pixbuf.opt_include}gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}glib-2.0
      -I#{glib.opt_lib}glib-2.0include
      -I#{gtkx.opt_include}gtk-2.0
      -I#{gtkx.opt_lib}gtk-2.0include
      -I#{harfbuzz.opt_include}harfbuzz
      -I#{include}gtkglext-1.0
      -I#{libpng.opt_include}libpng16
      -I#{lib}gtkglext-1.0include
      -I#{pango.opt_include}pango-1.0
      -I#{pixman.opt_include}pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lgio-2.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lgdk_pixbuf-2.0
      -lpango-1.0
      -lpangocairo-1.0
    ]

    if OS.mac?
      flags += %w[
        -lgdk-quartz-2.0
        -lgtk-quartz-2.0
        -lgdkglext-quartz-1.0
        -lgtkglext-quartz-1.0
        -lintl
        -framework AppKit
        -framework OpenGL
      ]
    end

    system ENV.cc, "test.c", "-o", "test", *flags
    system ".test"
  end
end

__END__
--- pangox-compatpangox.c.orig 2020-05-04 18:31:53.421197064 -0400
+++ pangox-compatpangox.c      2020-05-04 18:32:41.251146923 -0400
@@ -277,11 +277,11 @@ pango_x_font_class_init (PangoXFontClass
   object_class->finalize = pango_x_font_finalize;
   object_class->dispose = pango_x_font_dispose;

   font_class->describe = pango_x_font_describe;
   font_class->get_coverage = pango_x_font_get_coverage;
-  font_class->find_shaper = pango_x_font_find_shaper;
+  * font_class->find_shaper = pango_x_font_find_shaper; *
   font_class->get_glyph_extents = pango_x_font_get_glyph_extents;
   font_class->get_metrics = pango_x_font_get_metrics;
   font_class->get_font_map = pango_x_font_get_font_map;
 }