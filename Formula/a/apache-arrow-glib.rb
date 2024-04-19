class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https:arrow.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=arrowarrow-15.0.2apache-arrow-15.0.2.tar.gz"
  mirror "https:archive.apache.orgdistarrowarrow-15.0.2apache-arrow-15.0.2.tar.gz"
  sha256 "abbf97176db6a9e8186fe005e93320dac27c64562755c77de50a882eb6179ac6"
  license "Apache-2.0"
  revision 1
  head "https:github.comapachearrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "aceea3cb74002930da21bcbf98a152210c72c82b1a1da138b3e2c7e0ce699179"
    sha256 cellar: :any, arm64_ventura:  "063d17a1f0c2a7be6fac2b3299b8af173d0caaf879f7ed1701f3e9a3b00b3cd4"
    sha256 cellar: :any, arm64_monterey: "067b2f4acf575be4f846cb0849f14de5dfb82e31da320e07c11090acb392868b"
    sha256 cellar: :any, sonoma:         "bc5daf491af0050492960b8da28f7beab7653db05ee9b5d312ebc271d78c1b86"
    sha256 cellar: :any, ventura:        "036a8dcccba034c88f21a72425c2cf5e01892f73f153b1a980774bd8f98448ae"
    sha256 cellar: :any, monterey:       "72e40b6ae3d7fc96150a04d51b6df948255b9f682710bd0ca39cbc5052ff9956"
    sha256               x86_64_linux:   "75ddec98ee485c71033211408a3b18d9a7068e5b0dcba3fa07f38b4472357071"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "apache-arrow"
  depends_on "glib"

  fails_with gcc: "5"

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      recursive_dependencies
        .select { |d| d.name.match?(^llvm(@\d+)?$) }
        .map { |llvm_dep| llvm_dep.to_formula.opt_lib }
        .each { |llvm_lib| ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm_lib }
    end

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