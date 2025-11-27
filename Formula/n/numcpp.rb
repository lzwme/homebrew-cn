class Numcpp < Formula
  desc "C++ implementation of the Python Numpy library"
  homepage "https://dpilger26.github.io/NumCpp"
  url "https://ghfast.top/https://github.com/dpilger26/NumCpp/archive/refs/tags/Version_2.15.0.tar.gz"
  sha256 "2364365dde19060220714dfabb0370a358a30c41838a7078af88dcc2b855af7f"
  license "MIT"
  head "https://github.com/dpilger26/NumCpp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "94ab79f87d3d2e197deb9cffe87e346ff2d4c422182d63d3429b85657596f8bb"
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    assert_equal "1\n5\n9\n", shell_output("./test")
  end
end