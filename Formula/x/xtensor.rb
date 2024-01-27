class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "https:xtensor.readthedocs.ioenlatest"
  url "https:github.comxtensor-stackxtensorarchiverefstags0.25.0.tar.gz"
  sha256 "32d5d9fd23998c57e746c375a544edf544b74f0a18ad6bc3c38cbba968d5e6c7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2a53b207badf4396ee58f1232ee82ac91947c2e0b95d7fc2cb3ded050e117c13"
  end

  depends_on "cmake" => :build

  resource "xtl" do
    url "https:github.comxtensor-stackxtlarchiverefstags0.7.7.tar.gz"
    sha256 "44fb99fbf5e56af5c43619fc8c29aa58e5fad18f3ba6e7d9c55c111b62df1fbb"
  end

  def install
    resource("xtl").stage do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end

    system "cmake", ".", "-Dxtl_DIR=#{lib}cmakextl", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath"test.cc").write <<~EOS
      #include <iostream>
      #include "xtensorxarray.hpp"
      #include "xtensorxio.hpp"
      #include "xtensorxview.hpp"

      int main() {
        xt::xarray<double> arr1
          {{11.0, 12.0, 13.0},
           {21.0, 22.0, 23.0},
           {31.0, 32.0, 33.0}};

        xt::xarray<double> arr2
          {100.0, 200.0, 300.0};

        xt::xarray<double> res = xt::view(arr1, 1) + arr2;

        std::cout << res(2) << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cc", "-o", "test", "-I#{include}"
    assert_equal "323", shell_output(".test").chomp
  end
end