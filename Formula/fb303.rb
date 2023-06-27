class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghproxy.com/https://github.com/facebook/fb303/archive/refs/tags/v2023.06.12.00.tar.gz"
  sha256 "f9cdc2f6631e09707ed5f9afe8b3b9acb94b9a3c04dc896d7570a07290024292"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f7a53941ebefe2f972c19e85ac17931286f8205e0fbf7590a228c724c834d811"
    sha256 cellar: :any,                 arm64_monterey: "a573c303a7cbccd563b2e28d1119eaf632de85715f8716fd99c06e922fc698c5"
    sha256 cellar: :any,                 arm64_big_sur:  "6425f283c67f1f32cfcad47917450c82dff9726500118b11879e57a34d9018d6"
    sha256 cellar: :any,                 ventura:        "8d3edeeb5a1eb42c4325c177d6074be5522f23ca89db11787b46d38d8fe09028"
    sha256 cellar: :any,                 monterey:       "86907d0326eb5bcdf2b9e0a9a740ab29a3d007ef08ebdb3ed7dafb07241f44df"
    sha256 cellar: :any,                 big_sur:        "fec7771166cb1d23d4389bdee3fe44a662d3b5bdceceee9e2068fc42e5449532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d85735caf888ee8b620d38f0174ac7e4669a68c32d26a3f1640d2804c5a3a7de"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"
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
                    "-I#{include}", "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end