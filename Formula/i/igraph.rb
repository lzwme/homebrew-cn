class Igraph < Formula
  desc "Network analysis package"
  homepage "https:igraph.org"
  url "https:github.comigraphigraphreleasesdownload0.10.9igraph-0.10.9.tar.gz"
  sha256 "cade6db7edbd7b6f715706c88ac51cb95dd27512ce5bdc736dcdcb2efcacb5cc"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3ced81f628d95542cf628bef61221bbb0357863f77ccce029bf2f8d017987401"
    sha256 cellar: :any,                 arm64_ventura:  "af729712151fed548cad371cc2f2ec8c44b7854bf91c54cc7a2a4b87533d2ef9"
    sha256 cellar: :any,                 arm64_monterey: "f18be7a489abce5384078aa480fbd56acab5dfa6c9ac9f6a5166bb05314d7a2b"
    sha256 cellar: :any,                 sonoma:         "a9f44723f827b1cdb92f09b63ef476b3f2075f313925bc8f6fa217ed4454c0b0"
    sha256 cellar: :any,                 ventura:        "86d6bac7b610b98b74485fd9bf5cd5de6a6dd8b0091b6dc8e246d25135167ed9"
    sha256 cellar: :any,                 monterey:       "a0f1959352dd49714d37bec1671f7d282611ff18ed398af041c70af806d8225c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bbd97f01cdc3b37f07fc58bdcb354591f1aa6d2c7a5225fec245f40a31c1e2d"
  end

  depends_on "cmake" => :build
  depends_on "arpack"
  depends_on "glpk"
  depends_on "gmp"
  depends_on "openblas"

  uses_from_macos "libxml2"

  def install
    mkdir "build" do
      # explanation of extra options:
      # * we want a shared library, not a static one
      # * link-time optimization should be enabled if the compiler supports it
      # * thread-local storage of global variables is enabled
      # * force the usage of external dependencies from Homebrew where possible
      # * GraphML support should be compiled in (needs libxml2)
      # * BLAS and LAPACK should come from OpenBLAS
      # * prevent the usage of ccache even if it is installed to ensure that we
      #    have a clean build
      system "cmake", "-G", "Unix Makefiles",
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
                      "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <igraph.h>
      int main(void) {
        igraph_real_t diameter;
        igraph_t graph;
        igraph_rng_seed(igraph_rng_default(), 42);
        igraph_erdos_renyi_game(&graph, IGRAPH_ERDOS_RENYI_GNP, 1000, 5.01000, IGRAPH_UNDIRECTED, IGRAPH_NO_LOOPS);
        igraph_diameter(&graph, &diameter, 0, 0, 0, 0, IGRAPH_UNDIRECTED, 1);
        printf("Diameter = %f\\n", (double) diameter);
        igraph_destroy(&graph);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}igraph", "-L#{lib}",
                   "-ligraph", "-lm", "-o", "test"
    assert_match "Diameter = 8", shell_output(".test")
  end
end