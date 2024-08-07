class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2024.08.05.00.tar.gz"
  sha256 "7f290952209612f3ac9bce3e775c3d1ea35ce15ceebc63dbd2ecc65393bea632"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8cd40d8939ade6e0eee915014cce96eb46b48b4f966f6887a2cbc936bdcd4f58"
    sha256 cellar: :any,                 arm64_ventura:  "1efcbe8d2ad599f8336a708b5ef66d658c86ba8c4250076babaa960cd600e37d"
    sha256 cellar: :any,                 arm64_monterey: "1dea321312893c91d3b87c2a16fa1fb81d2daad80108fe7f1a6d161b8f9f6b87"
    sha256 cellar: :any,                 sonoma:         "bd56e91327935a02623f7da390f591a0801fa0db6254ae62c8454acae5450f4a"
    sha256 cellar: :any,                 ventura:        "adf6c95459a32f88af3a62f45abbc2916e1ee4056820a54e8be8186ec074ae16"
    sha256 cellar: :any,                 monterey:       "f55e68e74e990a27559fc08dbd45e9fb34fb61214a6f04c7c5e9cd6607d04ae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8a83e011385f5554e0894a6237e7b8acd7350dc1c00cf8b37f48fcb301b3302"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  fails_with gcc: "5" # C++17

  def install
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-DPYTHON_EXTENSIONS=OFF", *shared_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include "fb303thriftgen-cpp2BaseService.h"
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
    assert_equal "BaseService", shell_output(".test").strip
  end
end