class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-14.0.0/apache-arrow-14.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-14.0.0/apache-arrow-14.0.0.tar.gz"
  sha256 "4eb0da50ec071baf15fc163cb48058931e006f1c862c8def0e180fd07d531021"
  license "Apache-2.0"
  head "https://github.com/apache/arrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "e365f70f9cb359f1ad6c5ecee0dc8b6130d8fd7c67599922f8b0d88a866457ae"
    sha256 cellar: :any, arm64_ventura:  "c5fee52cc5506202e0eca6f9c66c3071f4b63fdbe3e52f8330d3076b60c6b7bf"
    sha256 cellar: :any, arm64_monterey: "b13c025240569a9ccbd5b2f22ec3ec86115e5e6742f949cc212295d715bc93dd"
    sha256 cellar: :any, sonoma:         "c6dadc89791dda199a70dcdae4c8b0b80ea5bbfac54ab05a5e53528885fc0769"
    sha256 cellar: :any, ventura:        "33568d1a74202f2238fb63f81e5ea9f1fa16b6e430837c053aa029330abf6d5e"
    sha256 cellar: :any, monterey:       "a8d1d99f772d29c36c8e81def45930998f5a69fbc47d1385d5c16f4501961eb6"
    sha256               x86_64_linux:   "861c816cf38c5e4853e0f57e5e2156904733b5e1ca009f36107bd20c30eb02d1"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "apache-arrow"
  depends_on "glib"

  fails_with gcc: "5"

  def install
    system "meson", "setup", "build", "c_glib", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~SOURCE
      #include <arrow-glib/arrow-glib.h>
      int main(void) {
        GArrowNullArray *array = garrow_null_array_new(10);
        g_object_unref(array);
        return 0;
      }
    SOURCE
    apache_arrow = Formula["apache-arrow"]
    glib = Formula["glib"]
    flags = %W[
      -I#{include}
      -I#{apache_arrow.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -L#{lib}
      -L#{apache_arrow.opt_lib}
      -L#{glib.opt_lib}
      -DNDEBUG
      -larrow-glib
      -larrow
      -lglib-2.0
      -lgobject-2.0
      -lgio-2.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end