class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghproxy.com/https://github.com/facebook/fb303/archive/refs/tags/v2023.10.02.00.tar.gz"
  sha256 "e38c664dfc1aa57d60bca3386694cd36c3e3f7f3f987fa85ab8a554782ed02e4"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "242d843405877261fb47a6724c412909d0c4a1e767b9091f6b92517e7ca2900c"
    sha256 cellar: :any,                 arm64_ventura:  "6c06990395e265b64acabf7a89c48271b38fa2536663155b72afd0a8643ab00f"
    sha256 cellar: :any,                 arm64_monterey: "984f6e602d6af7d489c6363c28da80c8d4717696a65b2511981bd2ccfaafb4b5"
    sha256 cellar: :any,                 sonoma:         "121f6bc6f04041fb0d873c1083c0494100006822ec1589abe3e75e6f464fd6fe"
    sha256 cellar: :any,                 ventura:        "87da953daa4bf46d714ca542a6c7ae7fa6da448efba11f92b7c22aaa0a58e2e9"
    sha256 cellar: :any,                 monterey:       "c2842f6b141005fb623134f05fcd97561538661735373993e155b125a1d4ac32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5153aaaa3595318823a8213c143fac064c03658ad96e08dceb2eb923dbe05f86"
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