class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghproxy.com/https://github.com/facebook/fb303/archive/v2023.04.10.00.tar.gz"
  sha256 "dea4b4f474f66f9f3d0a8a17d376e3fd2dff2bbd6c0b4f35188fce944377aecf"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0682c34348fed1157541e46dfa4c2ff97ef8a1ac25214f72afb524c68bfef220"
    sha256 cellar: :any,                 arm64_monterey: "d779d0be5fbc26a492a6bad46754c2844874ba70c2d7ddff689c54970861a50a"
    sha256 cellar: :any,                 arm64_big_sur:  "75bf591c780f33a4d332d0cd40e613f428fedee426ad41f56777c87346519eec"
    sha256 cellar: :any,                 ventura:        "5b667bed56392411f76210b89f68e6986bca9727adfba5092f918e225f533879"
    sha256 cellar: :any,                 monterey:       "4d6f8fe8b1f2cf9203c7528c9fc2d3a0dab606c815c7f8915a870bbfb7ed5d01"
    sha256 cellar: :any,                 big_sur:        "1d8dcfcd8450a797da166861b2803355bb2b975fbdb98782b07a886358d752ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48b9071eb9a8777cc21872eb149e0fcdd1e793bf5ee2eecbdcbe58192ac987dd"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@1.1"
  depends_on "wangle"

  fails_with gcc: "5" # C++17

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXTENSIONS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "fb303/thrift/gen-cpp2/BaseService.h"
      #include <iostream>
      int main() {
        auto service = facebook::fb303::cpp2::BaseServiceSvIf();
        std::cout << service.getGeneratedName() << std::endl;
        return 0;
      }
    EOS

    if Tab.for_formula(Formula["folly"]).built_as_bottle
      ENV.remove_from_cflags "-march=native"
      ENV.append_to_cflags "-march=#{Hardware.oldest_cpu}" if Hardware::CPU.intel?
    end

    ENV.append "CXXFLAGS", "-std=c++17"
    system ENV.cxx, *ENV.cxxflags.split, "test.cpp", "-o", "test",
                    "-I#{include}", "-I#{Formula["openssl@1.1"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end