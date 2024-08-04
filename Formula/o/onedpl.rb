class Onedpl < Formula
  desc "C++ standard library algorithms with support for execution policies"
  homepage "https:software.intel.comcontentwwwusendeveloptoolsoneapicomponentsdpc-library.html"
  url "https:github.comoneapi-srconeDPLarchiverefstagsoneDPL-2022.0.0-release.tar.gz"
  sha256 "e22eb0155258abdccd810dc131baa3eac4a856507b6eef37462a077d37cd810e"
  # Apache License Version 2.0 with LLVM exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(^oneDPL[._-](\d+(?:\.\d+)+)(?:[._-]release)?$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "41a83601bb2bb9542dcdbfa8c3f8dcfd542834ef0277013c85d21199759f9af7"
  end

  depends_on "cmake" => :build
  depends_on "tbb"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    # `cmake --build build` is for tests
    system "cmake", "--install", "build"
  end

  test do
    tbb = Formula["tbb"]

    (testpath"test.cpp").write <<~EOS
      #include <oneapidplexecution>
      #include <oneapidplalgorithm>
      #include <array>
      #include <assert.h>

      int main() {
        std::array<int, 10> arr {{5,2,3,1,4,9,7,0,8,6}};
        dpl::sort(dpl::execution::par_unseq, arr.begin(), arr.end());
        for(int i=0; i<10; i++)
          assert(i==arr.at(i));
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{tbb.opt_lib}", "-ltbb", "-I#{tbb.opt_include}",
                    "-I#{prefix}stdlib", "-I#{include}", "-o", "test"
    system ".test"
  end
end