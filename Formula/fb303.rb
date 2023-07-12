class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghproxy.com/https://github.com/facebook/fb303/archive/refs/tags/v2023.07.10.00.tar.gz"
  sha256 "0293859ce7727a8357ee1c98a552a0889cfec4865a1bbc81d71ef8442f53b769"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "390f3777708b871132c9a62d133123bb33733aea93df59de1aead53084d02548"
    sha256 cellar: :any,                 arm64_monterey: "b20d1d11b2d06ef7558ae0cd6ffdee3b0d196ae2b446c5c98b5bd3baf2983701"
    sha256 cellar: :any,                 arm64_big_sur:  "621f252155e5e53ebf58d64c802b2591004fc82056aa4d3a2d399e3e91ea2f9f"
    sha256 cellar: :any,                 ventura:        "21f004d2e7dca10467660e9ceab58e8bceb8aafa5e25c987f9ddfa74d3cc44a4"
    sha256 cellar: :any,                 monterey:       "c970cca7c153c1b064e3ee9365b1b36c2fd24612eec2faf793c07b6ce9eba95f"
    sha256 cellar: :any,                 big_sur:        "73bc294675047016c80eb18a2490056af6f2740e099dacc47e28e28247b4f845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7178f57814111b97695f623c98e2de029ddb9f242f74ae2f6d2cd92aebd8e0c6"
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