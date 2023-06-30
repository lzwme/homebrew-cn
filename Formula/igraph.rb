class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://ghproxy.com/https://github.com/igraph/igraph/releases/download/0.10.5/igraph-0.10.5.tar.gz"
  sha256 "1c2725122fda9b72065095794bc7748939d90d942d312cb63c6160cd98d50f1e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cb9b57e7a003e4b1a5828f6bf253e55824f66dc1fc651d3121de6f8fcf94a9ee"
    sha256 cellar: :any,                 arm64_monterey: "fef6cb2de8fa8c258f8ab8240ec7c98987d01b3edc13c7370671b56fbc55dbd1"
    sha256 cellar: :any,                 arm64_big_sur:  "7ac98ef8cada979601ea087b6cdf0fd1d40981db5c705e5bc3d386569d4ba9bf"
    sha256 cellar: :any,                 ventura:        "c0a3976cd359eaee239a340d71a9d3f7d41884efdca4addaa9bc00bdc531ad0f"
    sha256 cellar: :any,                 monterey:       "87ad6908ab20d87b1d979eb1aa4803c1afde91f6f4586f754c29c7e8af22a8dc"
    sha256 cellar: :any,                 big_sur:        "5398c6f148c8debb283311dbba0310d51450c88c3a886b44cac937955f5fc87b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4cb7ccc3759969e226a8abf416faabe26610387c1fd845b73cbbbb956209c2a"
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
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-I#{include}/igraph", "-L#{lib}",
                   "-ligraph", "-lm", "-o", "test"
    assert_match "Diameter = 8", shell_output("./test")
  end
end