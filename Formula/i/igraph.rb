class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://ghfast.top/https://github.com/igraph/igraph/releases/download/0.10.17/igraph-0.10.17.tar.gz"
  sha256 "21016ecf309a235f2bd9e208606d5a24c14a1f701dd7b2497e2e5f6bf2c5f848"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1952a5e2dbb135c4b7c238439355888c4d3ef0adccbae0ac2362e67c572e389e"
    sha256 cellar: :any,                 arm64_sequoia: "6f7f3226fe43bb58d8b8534a5ab9b4a6aba6ca748966641641c090b03399c1a1"
    sha256 cellar: :any,                 arm64_sonoma:  "643e7e0f1860e63e22821c75ef234cafb8db07b53149faaec8f1741a1d98d780"
    sha256 cellar: :any,                 sonoma:        "d13950d4c33d4381756fcfa6f9e49ce5d989a64714ce70eb14cf54f0240ad38e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57ca10ca517a1ffdfb9f203ee1c0081c359d9dc7de2fb2b9bcb43c463367ec77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d65856a8832d1f62ff2663ce9369236a0ef8ce067e10d1d0b6232bcc8942a814"
  end

  depends_on "cmake" => :build
  depends_on "arpack"
  depends_on "glpk"
  depends_on "gmp"
  depends_on "openblas"

  uses_from_macos "libxml2"

  def install
    # explanation of extra options:
    # * we want a shared library, not a static one
    # * link-time optimization should be enabled if the compiler supports it
    # * thread-local storage of global variables is enabled
    # * force the usage of external dependencies from Homebrew where possible
    # * GraphML support should be compiled in (needs libxml2)
    # * BLAS and LAPACK should come from OpenBLAS
    # * prevent the usage of ccache even if it is installed to ensure that we
    #    have a clean build
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DIGRAPH_ENABLE_LTO=AUTO",
                    "-DIGRAPH_ENABLE_TLS=ON",
                    "-DIGRAPH_GLPK_SUPPORT=ON",
                    "-DIGRAPH_GRAPHML_SUPPORT=ON",
                    "-DIGRAPH_USE_INTERNAL_ARPACK=OFF",
                    "-DIGRAPH_USE_INTERNAL_BLAS=OFF",
                    "-DIGRAPH_USE_INTERNAL_GLPK=OFF",
                    "-DIGRAPH_USE_INTERNAL_GMP=OFF",
                    "-DIGRAPH_USE_INTERNAL_LAPACK=OFF",
                    "-DBLA_VENDOR=OpenBLAS",
                    "-DUSE_CCACHE=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <igraph.h>
      int main(void) {
        igraph_real_t diameter;
        igraph_t graph;
        igraph_rng_seed(igraph_rng_default(), 42);
        igraph_erdos_renyi_game(&graph, IGRAPH_ERDOS_RENYI_GNP, 1000, 5.0/1000, IGRAPH_UNDIRECTED, IGRAPH_NO_LOOPS);
        igraph_diameter(&graph, &diameter, 0, 0, 0, 0, IGRAPH_UNDIRECTED, 1);
        printf("Diameter = %f\\n", (double) diameter);
        igraph_destroy(&graph);
      }
    C
    system ENV.cc, "test.c", "-I#{include}/igraph", "-L#{lib}",
                   "-ligraph", "-lm", "-o", "test"
    assert_match "Diameter = 8", shell_output("./test")
  end
end