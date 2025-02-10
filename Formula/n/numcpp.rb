class Numcpp < Formula
  desc "C++ implementation of the Python Numpy library"
  homepage "https:dpilger26.github.ioNumCpp"
  url "https:github.comdpilger26NumCpparchiverefstagsVersion_2.14.0.tar.gz"
  sha256 "f7d3a11d12f3209c95c098d0566e6aee072cfc493f1e9376796c91520958686f"
  license "MIT"
  head "https:github.comdpilger26NumCpp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "00b6562df214a160b99b910f7be4214b7324179d1326c4c5601fe75bba2eba7e"
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <iostream>
      #include <NumCpp.hpp>

      int main() {
          nc::NdArray<int> a = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};
          a = nc::diagonal(a);
          for (int i = 0; i < nc::shape(a).cols; ++i)
              std::cout << a[i] << std::endl;
      }
    CPP

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-I#{include}"
    assert_equal "1\n5\n9\n", shell_output(".test")
  end
end