class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://wiki.gnome.org/Projects/Libpeas"
  url "https://download.gnome.org/sources/libpeas/1.34/libpeas-1.34.0.tar.xz"
  sha256 "4305f715dab4b5ad3e8007daec316625e7065a94e63e25ef55eb1efb964a7bf0"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 2
    sha256 arm64_ventura:  "931d612a200796786da9b95634fa0dc424cb79981762e450659a24fb74bdabd7"
    sha256 arm64_monterey: "ca93cd9743107022396b92f4fa1f9574a9e4d0d0609c53d6f299d589e2be6a59"
    sha256 arm64_big_sur:  "582870b6ef61be3fa3841144caf062924477398674752c031982d043a9890185"
    sha256 ventura:        "68b324965542b1042322eb5a44f7c0bf574edee82a7ae50da8df90c31224b7d4"
    sha256 monterey:       "af87c25fcfa4c06b28260e830d2d2143bb725a44639f8fc9cfbb1c9b2195f189"
    sha256 big_sur:        "ad3f6036bd758f1e23dfbd966a8448c9c080d74bd3bc4d076fc8e27da721d36a"
    sha256 x86_64_linux:   "e5f78bbc0f5036e08d3ef81a6a44c8220b73b673402761f361f13beaa806cecc"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.11"

  def install
    args = %w[
      -Dpython3=true
      -Dintrospection=true
      -Dvapi=true
      -Dwidgetry=true
      -Ddemos=false
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libpeas/peas.h>

      int main(int argc, char *argv[]) {
        PeasObjectModule *mod = peas_object_module_new("test", "test", FALSE);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gobject_introspection = Formula["gobject-introspection"]
    libffi = Formula["libffi"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gobject_introspection.opt_include}/gobject-introspection-1.0
      -I#{include}/libpeas-1.0
      -I#{libffi.opt_lib}/libffi-3.0.13/include
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gobject_introspection.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lgirepository-1.0
      -lglib-2.0
      -lgmodule-2.0
      -lgobject-2.0
      -lpeas-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end