class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https:arrow.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=arrowarrow-14.0.1apache-arrow-14.0.1.tar.gz"
  mirror "https:archive.apache.orgdistarrowarrow-14.0.1apache-arrow-14.0.1.tar.gz"
  sha256 "5c70eafb1011f9d124bafb328afe54f62cc5b9280b7080e1e3d668f78c0e407e"
  license "Apache-2.0"
  head "https:github.comapachearrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "25329142b0d24b9ba7ba72a1f81821baf4c760f5111aa09ed540c495a11c4f40"
    sha256 cellar: :any, arm64_ventura:  "3648d4b77e542ee34d5c4afc466598b445875c191457fd2e32cb58f0e6e5682b"
    sha256 cellar: :any, arm64_monterey: "00222b1e2a6a3484084447886e3b1ad1096993a9a9042955fb25ec248ee1922f"
    sha256 cellar: :any, sonoma:         "6c46faddbc9d63055b9883df39121f221769d727f3ddc39369d33f6e41e05890"
    sha256 cellar: :any, ventura:        "cdf4d75ac1a65d6ddb525b9ce83032695f5c0f1fd5759c687174302a5029e7e8"
    sha256 cellar: :any, monterey:       "9fb2a8757c67897765d74b014d6f5517008c489aa9ed1410cf20674759da83ce"
    sha256               x86_64_linux:   "9c343584a79109c7c07cca5a644b8ffdbcab5134f5b4df762fa287307f5f8b7c"
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
    (testpath"test.c").write <<~SOURCE
      #include <arrow-glibarrow-glib.h>
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
      -I#{glib.opt_include}glib-2.0
      -I#{glib.opt_lib}glib-2.0include
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
    system ".test"
  end
end