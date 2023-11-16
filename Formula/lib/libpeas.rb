class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://wiki.gnome.org/Projects/Libpeas"
  url "https://download.gnome.org/sources/libpeas/1.36/libpeas-1.36.0.tar.xz"
  sha256 "297cb9c2cccd8e8617623d1a3e8415b4530b8e5a893e3527bbfd1edd13237b4c"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "64ad8a90b23f3872951a88c7d039b93090548b911939b66146920c169b02ae11"
    sha256 arm64_ventura:  "7bdbcc97af2820929b7903c72719996d73346eddf9b5fb2c6155bb0f64195e99"
    sha256 arm64_monterey: "23bc7ec788fb30020b8ec94ee0840ab56e0294806ef8c671f28d42ccbe97d78a"
    sha256 sonoma:         "be7a1ecf84dee4276c4be25259ff185a6ff209d3ff25af154251ba718bd11530"
    sha256 ventura:        "51b49689824a60dbbd86b43bd0155b0761ab986de209337a10bb57a6145c57c2"
    sha256 monterey:       "9cfa0e4714aa857bccca9764f09942848124922fc3184d90c159191f40967852"
    sha256 x86_64_linux:   "786564f40ef81e40b300117b6dffdc9369abf4cac2c49a29cb3a16dc2be84d48"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.12"

  def install
    pyver = Language::Python.major_minor_version "python3.12"
    # Help pkg-config find python as we only provide `python3-embed` for aliased python formula
    inreplace "meson.build", "'python3-embed'", "'python-#{pyver}-embed'"

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