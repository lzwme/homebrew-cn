class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://ghproxy.com/https://github.com/igraph/igraph/releases/download/0.10.8/igraph-0.10.8.tar.gz"
  sha256 "ac5fa94ae6fd1eace651e4b235e99c056479a5c5d0d641aed30240ac33b19403"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ed772e6924ee9c55a022c65519d85ffa5b02261ced32b54d61250bf7f8e24830"
    sha256 cellar: :any,                 arm64_ventura:  "bc9bef8198f9aeb8d588b05b25853d2b20e2177f3d2d5d0d289567b54c4ee4da"
    sha256 cellar: :any,                 arm64_monterey: "f32c7cc9f03154e5296284fb727e130e217b151f4aa1ad25eae68e627aca1bc0"
    sha256 cellar: :any,                 sonoma:         "0d93a6369c84f78b02f95d871cf061f0070019bb64708b2f6493817496ec9751"
    sha256 cellar: :any,                 ventura:        "e72215cc6cb8ad21a4db3136cf7f40669308adbd9fc71290fa86f32722b3852a"
    sha256 cellar: :any,                 monterey:       "0f657f6629f6856902c27ca4b286098de29345138316f77ed3f74d969123dd56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daf9d2d524e80bbd6c06790cd9f6dc9ecff8e4c61361e78ad1f5616da8ce1a43"
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