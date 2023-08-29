class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghproxy.com/https://github.com/facebook/fb303/archive/refs/tags/v2023.08.28.00.tar.gz"
  sha256 "cbfeecc40b8fe801ff80c26e86ee645b87779919baf0a77e88ed1bfd1331b942"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "68b806457217e518b4502e24f1dd67e645f8b62aab8853e633e19c5c5b475a62"
    sha256 cellar: :any,                 arm64_monterey: "4a8ecb2666c7f7982e16fe472ee2bcbf5163ef45f8c47fc5f5208283d3493e07"
    sha256 cellar: :any,                 arm64_big_sur:  "3e80e446f4c33aeeef5f2e64b0750a3cb6611a624ba910a59c72bd2cab109034"
    sha256 cellar: :any,                 ventura:        "3e051e690aecce9fc9808e390725c1385edf8228a16b726a545e0c6adb23b48d"
    sha256 cellar: :any,                 monterey:       "4a5de3233e5c8bbd27a42b139575cc7c4c9dbef8e0be85874ff2260c059d2be4"
    sha256 cellar: :any,                 big_sur:        "d1a20e49b0e3f9bf3cc730e427b66ced0b6261456bdebe841c7a9e3b58fb2891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "034dc08a27b613cca917c0752e410f90361d701487cda7fd17a92080bc2111bf"
  end

  depends_on "cmake" => :build
  depends_on "mvfst" => :build
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