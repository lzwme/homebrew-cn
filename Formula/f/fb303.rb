class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghfast.top/https://github.com/facebook/fb303/archive/refs/tags/v2025.08.25.00.tar.gz"
  sha256 "5f7e6d7484ef58a0ffabf1610aa4938b0f6b166255b18cf8c111019972b786d3"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "cf2ebcbdfe6f9054633476ea7325605cac64c916895fc8677aab54d07ff6a134"
    sha256                               arm64_sonoma:  "fdf10643a4fe0867bf70f5f58e874c7aeb7193d4fae8af20d70d75b0722ba915"
    sha256                               arm64_ventura: "bdf730a32ea672b8c328749e65cb9893607c75f2cce0bc14617b482444bb3c97"
    sha256 cellar: :any,                 sonoma:        "f8ce0643b0f52ead732009a0b7da2a9779bcf2d21c64eafd201a5c511bec8bb2"
    sha256 cellar: :any,                 ventura:       "f8d9e62ccacdf5c300a56bf3fef0a961fa622de3dcf38021985d8a8c66c3bccd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9ad26257f8badfd3b5dcba3800296b4711fc35894af8e48cfc3dc374000b654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b40520ebbe927baea93a9f2f1ecba4e86866d5c4231483ac98548398049091c4"
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

  def install
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-DPYTHON_EXTENSIONS=OFF", *shared_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "fb303/thrift/gen-cpp2/BaseService.h"
      #include <iostream>
      int main() {
        auto service = facebook::fb303::cpp2::BaseServiceSvIf();
        std::cout << service.getGeneratedName() << std::endl;
        return 0;
      }
    CPP

    if Tab.for_formula(Formula["folly"]).built_as_bottle
      ENV.remove_from_cflags "-march=native"
      ENV.append_to_cflags "-march=#{Hardware.oldest_cpu}" if Hardware::CPU.intel?
    end

    ENV.append "CXXFLAGS", "-std=c++20"
    system ENV.cxx, *ENV.cxxflags.split, "test.cpp", "-o", "test",
                    "-I#{include}", "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end