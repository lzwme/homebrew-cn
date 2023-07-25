class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghproxy.com/https://github.com/facebook/fb303/archive/refs/tags/v2023.07.24.00.tar.gz"
  sha256 "689fe7e74cea683aef322055c897bf61a0690ea068698e941e68f10f44c7eaf8"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dfa13446045a3dc84adb587464bc18ba16ce255745e9c288918420b3be7d55c1"
    sha256 cellar: :any,                 arm64_monterey: "dea71c9354b4dfa30df67f0a03aae169feab42bb1b76322e25c1da1f95cafd2d"
    sha256 cellar: :any,                 arm64_big_sur:  "a010aa7d8595f7c030f28f20df5022e86e8b5ac3c078539c325d3a15745ec739"
    sha256 cellar: :any,                 ventura:        "8cbddcc037d2d7755cc7fac41febc932f7e09a27e5166ddc8278dcc136164291"
    sha256 cellar: :any,                 monterey:       "b2d69d4d75a63b661874a3c35791cd4910bd1e639e4aca5e03afd100513e6be5"
    sha256 cellar: :any,                 big_sur:        "13afe838ea83f34b8079f3b1fcc32863ed6df0cae4aa00b8a867533dc0c3e2d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed17311646ab15c27f29b2fb192be7f6e66a0747a6c77a93520a52e82f6b4687"
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