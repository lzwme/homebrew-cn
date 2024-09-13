class Libpeas < Formula
  desc "GObject plugin library"
  homepage "https://wiki.gnome.org/Projects/Libpeas"
  # TODO: Move to latest `spidermonkey` with gjs 1.82.x
  url "https://download.gnome.org/sources/libpeas/2.0/libpeas-2.0.3.tar.xz"
  sha256 "39e3b507c29d2d01df1345e9b3380fd7a9d0aeb5b2e657d38e6c2bea5023e5f0"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_sequoia:  "dfd2891b012dece5689092e8f20d1184f30b0267471764abea87ee941e5364a2"
    sha256 arm64_sonoma:   "639824f6fcd4036a4fdd1c3135b4cd0ec98baad246ee00cbcf5153e8281b0fdf"
    sha256 arm64_ventura:  "6494928bddeb9d2876cb32ff8fcb40414ac4f9c6f83ce3f17e07337381be4a27"
    sha256 arm64_monterey: "a3dd9eb7c382591a9503164059828d359d09c5673ead4ce151efbfe1df8a07a9"
    sha256 sonoma:         "f2f09e8b8b5f98eda1a8e0f87bc6a753f8c3f9c908c2bf188aba748cb3c027e2"
    sha256 ventura:        "c52899ef298323ccb0b7fd5b191677b3e042c08daf79da14fa919ce3bddf8fd3"
    sha256 monterey:       "38508ba0b4be708794a42b35554f13fc7ad02d85d72b5f663f82b2718d6fb834"
    sha256 x86_64_linux:   "2491531006192bc691a15aa39af728bdc5ce8c63091cd34e8b6758a04b8cd48f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gjs"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "python@3.12"
  depends_on "spidermonkey@115"

  on_macos do
    depends_on "gettext"
  end

  def install
    pyver = Language::Python.major_minor_version "python3.12"
    # Help pkg-config find python as we only provide `python3-embed` for aliased python formula
    inreplace "meson.build", "'python3-embed'", "'python-#{pyver}-embed'"

    args = %w[
      -Dlua51=false
      -Dpython3=true
      -Dintrospection=true
      -Dvapi=true
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libpeas.h>

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
      -I#{include}/libpeas-2
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
      -lpeas-2
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end