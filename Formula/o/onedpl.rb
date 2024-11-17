class Onedpl < Formula
  desc "C++ standard library algorithms with support for execution policies"
  homepage "https:github.comoneapi-srconeDPL"
  url "https:github.comoneapi-srconeDPLarchiverefstagsoneDPL-2022.7.0-release.tar.gz"
  sha256 "095be49a9f54633d716e82f66cc3f1e5e858f19ef47639e4c94bfc6864292990"
  # Apache License Version 2.0 with LLVM exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(^oneDPL[._-](\d+(?:\.\d+)+)(?:[._-]release)?$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "88367f230d58db36bede6ddfe1107a36e4e1c1991220f63de4cf1d9215218f13"
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

    (testpath"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{tbb.opt_lib}", "-ltbb", "-I#{tbb.opt_include}",
                    "-I#{prefix}stdlib", "-I#{include}", "-o", "test"
    system ".test"
  end
end