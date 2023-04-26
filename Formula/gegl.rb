class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "https://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.4/gegl-0.4.44.tar.xz"
  sha256 "0a4cdb41635e406a0849cd0d3f03caf7d97cab8aa13d28707d532d0089d56126"
  license all_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later", "BSD-3-Clause", "MIT"]
  revision 1
  head "https://gitlab.gnome.org/GNOME/gegl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/gegl/0.4/"
    regex(/href=.*?gegl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "c3083b8599602d9d130ba43b497af36d14f223a0dd6b52b14bd0ae46cf4fedba"
    sha256 arm64_monterey: "53bc2550ba65f022d386589d29a7ed8b37e07cd1616d8c041e3da3250bef2b81"
    sha256 arm64_big_sur:  "b40b52dd843ace0cc29e5c4ad04331d1558edb04408e16cf39287df46897e882"
    sha256 ventura:        "c4b71927a74f21c21944b5833c9f6972bfe083eec9ecb3d66ba5778c39999f8d"
    sha256 monterey:       "3aeabd2ab6ea22d9b100160f9c1b9c0da81f6950cb845c8ee8debbf99571f80e"
    sha256 big_sur:        "c7f91baa51527665d07e3a2d8a98d49d6533d9aac4f0ec4cb8767547ba725653"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "babl"
  depends_on "gettext"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "json-glib"
  depends_on "libpng"

  on_linux do
    depends_on "cairo"
  end

  def install
    ### Temporary Fix ###
    # Temporary fix for a meson bug
    # Upstream appears to still be deciding on a permanent fix
    # See: https://gitlab.gnome.org/GNOME/gegl/-/issues/214
    inreplace "subprojects/poly2tri-c/meson.build",
      "libpoly2tri_c = static_library('poly2tri-c',",
      "libpoly2tri_c = static_library('poly2tri-c', 'EMPTYFILE.c',"
    touch "subprojects/poly2tri-c/EMPTYFILE.c"
    ### END Temporary Fix ###

    system "meson", *std_meson_args, "build",
                    "-Ddocs=false",
                    "-Dcairo=disabled",
                    "-Djasper=disabled",
                    "-Dumfpack=disabled",
                    "-Dlibspiro=disabled",
                    "--force-fallback-for=libnsgif,poly2tri-c"
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gegl.h>
      gint main(gint argc, gchar **argv) {
        gegl_init(&argc, &argv);
        GeglNode *gegl = gegl_node_new ();
        gegl_exit();
        return 0;
      }
    EOS
    system ENV.cc,
           "-I#{Formula["babl"].opt_include}/babl-0.1",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-L#{Formula["glib"].opt_lib}", "-lgobject-2.0", "-lglib-2.0",
           testpath/"test.c",
           "-I#{include}/gegl-0.4", "-L#{lib}", "-lgegl-0.4",
           "-o", testpath/"test"
    system "./test"
  end
end