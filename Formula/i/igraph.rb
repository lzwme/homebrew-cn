class Igraph < Formula
  desc "Network analysis package"
  homepage "https:igraph.org"
  url "https:github.comigraphigraphreleasesdownload0.10.15igraph-0.10.15.tar.gz"
  sha256 "03ba01db0544c4e32e51ab66f2356a034394533f61b4e14d769b9bbf5ad5e52c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bd56ca8e66713f2f94eb60d15ee8da571f3d1ce271f769fd9918245e1fc69548"
    sha256 cellar: :any,                 arm64_sonoma:  "8f8da1ffb57030d63905b11be3ff94336583883088511660b2d6e12c032a0874"
    sha256 cellar: :any,                 arm64_ventura: "a0e18afcfd17531d5f133febfad72ff8fd44dc556823f6a71867e27299960f69"
    sha256 cellar: :any,                 sonoma:        "f6e7880c9e494221a27e61c84b29206241f3fe0651543717b845d944e4cceeb2"
    sha256 cellar: :any,                 ventura:       "0b456d986d1b04ad13389f1ae31c879734b1f5165db0c5191c90590332a93263"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8fe94047b95c5a3bc21f9334ecd4843223916251843f5ff9822ed446c704465"
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
    (testpath"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{include}igraph", "-L#{lib}",
                   "-ligraph", "-lm", "-o", "test"
    assert_match "Diameter = 8", shell_output(".test")
  end
end