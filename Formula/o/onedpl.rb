class Onedpl < Formula
  desc "C++ standard library algorithms with support for execution policies"
  homepage "https://github.com/uxlfoundation/oneDPL"
  url "https://ghfast.top/https://github.com/uxlfoundation/oneDPL/archive/refs/tags/oneDPL-2022.9.0-release.tar.gz"
  sha256 "b38844878af9ecee07ca719426b90fec77f79a35c7bc55154422cb0d7f654343"
  # Apache License Version 2.0 with LLVM exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "72e973dd99028596ed7ac87d7aadc5594b91451eb6c69b0a248c6e9ba837661e"
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

    (testpath/"test.cpp").write <<~CPP
      #include <oneapi/dpl/execution>
      #include <oneapi/dpl/algorithm>
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
                    "-I#{prefix}/stdlib", "-I#{include}", "-o", "test"
    system "./test"
  end
end