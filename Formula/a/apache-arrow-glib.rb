class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https:arrow.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=arrowarrow-16.1.0apache-arrow-16.1.0.tar.gz"
  mirror "https:archive.apache.orgdistarrowarrow-16.1.0apache-arrow-16.1.0.tar.gz"
  sha256 "c9e60c7e87e59383d21b20dc874b17153729ee153264af6d21654b7dff2c60d7"
  license "Apache-2.0"
  head "https:github.comapachearrow.git", branch: "main"

  livecheck do
    formula "apache-arrow"
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "4448204d5fca55b68d554a866fa2acf0415afc6a19b951357710c7d6ff595245"
    sha256 cellar: :any, arm64_ventura:  "abcdd0a46ba83fc334b3df07acb7e3549d1ce4b7bee3da2f15b3ce84788db93f"
    sha256 cellar: :any, arm64_monterey: "2a5aaab56d1d36f6b134ef34326ed898c370d95dbd3d17d41074c4dfd878ffa3"
    sha256 cellar: :any, sonoma:         "10bf14ecfef9b6d5aaf183ae69c06f72343b25fb3c19cb5d051b422a151b9b2a"
    sha256 cellar: :any, ventura:        "ff29241764241902e503f6df492b6c0a94305a90f93a2ae744f3f00f0af80e15"
    sha256 cellar: :any, monterey:       "991a209db1009073562087dc3e2929780859ff6e446b17d27541dcddd59db396"
    sha256               x86_64_linux:   "727465929b44a12d77b20446deea556fd6b24052ab8192709bd17c470ccd4db1"
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