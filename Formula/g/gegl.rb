class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "https://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.4/gegl-0.4.56.tar.xz"
  sha256 "a04a64b90f9b5ac9ae5643401c7d5eb3cb41f42c52ce9787089b5d2a2dd3cc5c"
  license all_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later", "BSD-3-Clause", "MIT"]
  head "https://gitlab.gnome.org/GNOME/gegl.git", branch: "master"

  livecheck do
    url "https://download.gimp.org/pub/gegl/0.4/"
    regex(/href=.*?gegl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "8e762d3968390721fd9e20b8d719b7c7fb0f5f86dc317555ece92a2c8a5dba9b"
    sha256 arm64_sonoma:  "63af32d6c0be7cc58488ca3e56f452c696cb3b4f380e524b011525bdf30d458b"
    sha256 arm64_ventura: "aeec62033b2069abfa708d8e747404b7a45a89e84e64621d2ab5acff64463ea3"
    sha256 sonoma:        "5b75460c53c04b6468f61c0a54bccd955f9b3c16c71e35bed5382bc33c8a3b33"
    sha256 ventura:       "391b52930fb2942495ff33d4da88507ed81a60ed57d77dbaa33132952a63cf6d"
    sha256 x86_64_linux:  "b466a750a9522784d94dbe13ef96b1ff660def99d7c38534791863e5dfbf514c"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "babl"
  depends_on "cairo"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "json-glib"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "poppler"
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

    args = %w[
      -Ddocs=false
      -Djasper=disabled
      -Dumfpack=disabled
      -Dlibspiro=disabled
      --force-fallback-for=libnsgif,poly2tri-c
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gegl.h>
      gint main(gint argc, gchar **argv) {
        gegl_init(&argc, &argv);
        GeglNode *gegl = gegl_node_new ();
        gegl_exit();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test",
                   "-I#{Formula["babl"].opt_include}/babl-0.1",
                   "-I#{Formula["glib"].opt_include}/glib-2.0",
                   "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
                   "-I#{include}/gegl-0.4",
                   "-L#{lib}", "-lgegl-0.4",
                   "-L#{Formula["glib"].opt_lib}", "-lgobject-2.0", "-lglib-2.0"
    system "./test"
  end
end