class Libnetworkit < Formula
  desc "NetworKit is an OS-toolkit for large-scale network analysis"
  homepage "https:networkit.github.io"
  url "https:github.comnetworkitnetworkitarchiverefstags11.0.1.tar.gz"
  sha256 "fbdc86b6ac6486ce4e0898f386c5371bd07b9a420293306f2e632549378f4b86"
  license "MIT"

  livecheck do
    formula "networkit"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "979a10b9b22a6b62428e9e2fbfd3e053f8a8e77361f2baac63a1bda73545af92"
    sha256 cellar: :any,                 arm64_sonoma:  "45494707da7380f58d607b5cd0b2168a9f58a17a588ae57070d66c8bfcacd956"
    sha256 cellar: :any,                 arm64_ventura: "6036015738905fb86f1651492e6a0575be48926460dc6fd545f19d9b41489f67"
    sha256 cellar: :any,                 sonoma:        "039b9ea8c75a1d6422582e059634bf5bf97e3c83828dae0ac54ea231fa847659"
    sha256 cellar: :any,                 ventura:       "f8aa5a83ed8b7785a53c7ec63f6ab410fdc242e13efb3ea082c3cfd4902b0373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e14848c11c3d18ddf4f62f996affdfbd75664279cb343ea7c7357bf413ccd5c"
  end

  depends_on "cmake" => :build
  depends_on "tlx"
  depends_on "ttmath"

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DNETWORKIT_EXT_TLX=#{Formula["tlx"].opt_prefix}",
                    "-DNETWORKIT_CXX_STANDARD=17",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <networkitgraphGraph.hpp>
      int main()
      {
         Try to create a graph with five nodes
        NetworKit::Graph g(5);
        return 0;
      }
    CPP
    omp_flags = OS.mac? ? ["-I#{Formula["libomp"].opt_include}"] : []
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lnetworkit", "-o", "test", *omp_flags
    system ".test"
  end
end