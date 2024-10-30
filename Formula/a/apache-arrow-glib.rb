class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https:arrow.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=arrowarrow-18.0.0apache-arrow-18.0.0.tar.gz"
  mirror "https:archive.apache.orgdistarrowarrow-18.0.0apache-arrow-18.0.0.tar.gz"
  sha256 "abcf1934cd0cdddd33664e9f2d9a251d6c55239d1122ad0ed223b13a583c82a9"
  license "Apache-2.0"
  head "https:github.comapachearrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "a0b28fa6491a7c46d5a39700294ba788f3850a6fe9835b6735ddf4a68a07b33f"
    sha256 cellar: :any, arm64_sonoma:  "c4d708695d8f80825fbff161662207a82a9ec506abc913e3e33c05ce17356fab"
    sha256 cellar: :any, arm64_ventura: "71aa90768fce1f8fc8edbd7b952ab9e1bf739d7f0e19b24e2f196f62384f64aa"
    sha256 cellar: :any, sonoma:        "d3f50856edd406643d163472bf910a6c1058fa16871bb46f6ada5508fb3fef34"
    sha256 cellar: :any, ventura:       "e488887b029117251bb4b7a5885de883d63030684f588885f9226eb408525115"
    sha256               x86_64_linux:  "264ffff72a0d935ccfe7f9178fa762d9809ca71c329ada7a21e472f1151873cb"
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