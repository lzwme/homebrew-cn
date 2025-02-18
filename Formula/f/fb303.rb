class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2025.02.17.00.tar.gz"
  sha256 "313066a9519e98ce5363a5aaf70c439d00a4103d4d43198dcb3e36da3ca20ac7"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6d2dd3f881a2962c23fc228adc932f42d6a772587301f47965e71bf28c7e5c84"
    sha256 cellar: :any,                 arm64_sonoma:  "301717f043881bd85f83b7c9983edad33029015b72d2fd4fbe0b0b35734e730c"
    sha256 cellar: :any,                 arm64_ventura: "c966d377b018929eaabdb11ce1c9fa48d3c25ff0ab7e5aa8df28eabb1f727692"
    sha256 cellar: :any,                 sonoma:        "6a51032f84b37fb1cdf4759a0a1dba12e6b48bf27334a9dc31cf66683e584d7c"
    sha256 cellar: :any,                 ventura:       "66ea2b31a69ff17cf237c78762c989fce42bb49a67cfebe315a2136d9c688ba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "904f59fc0ab10bc2c07d32815df2264a9cb83d59307d1a9a3221f70ff0af4461"
  end

  depends_on "cmake" => :build
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
    (testpath"test.cpp").write <<~CPP
      #include "fb303thriftgen-cpp2BaseService.h"
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

    ENV.append "CXXFLAGS", "-std=c++17"
    system ENV.cxx, *ENV.cxxflags.split, "test.cpp", "-o", "test",
                    "-I#{include}", "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-ldl"
    assert_equal "BaseService", shell_output(".test").strip
  end
end