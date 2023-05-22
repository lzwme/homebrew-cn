class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghproxy.com/https://github.com/facebook/fb303/archive/refs/tags/v2023.05.15.00.tar.gz"
  sha256 "8aba581414461149e5be21f2d7ee40f7e6c62922a23c73524bf2e7d677aac355"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dadee3e83781c96273d09a0e8862adb08f0115372024e6888f329f6e0d697332"
    sha256 cellar: :any,                 arm64_monterey: "3bee23d7f0dc07a6e30e54896c8a02446609dab22394afc0a10770a6bcf89601"
    sha256 cellar: :any,                 arm64_big_sur:  "866d5beb471b87adf1fb0df7651126dff0f9bd4ea7d786012e547ab835cba550"
    sha256 cellar: :any,                 ventura:        "52e5cef9d84260bf801f0b40828a11e8c9913e2693d73faec3fba6af0ee59ceb"
    sha256 cellar: :any,                 monterey:       "d1bff03dbca71dc21421fb4ff60a15695b73587e97b76daac36eac4d18221cad"
    sha256 cellar: :any,                 big_sur:        "8fc7a6d1231f027870ab80f9427290b6b6106aedaff339b28ca41c5c3b3fd6be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed0d9c55352c8d4c8f42b997a277de232a865bb95f56567289ef82b481173fc8"
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