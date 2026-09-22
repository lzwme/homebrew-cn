class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghfast.top/https://github.com/facebook/fb303/archive/refs/tags/v2026.09.21.00.tar.gz"
  sha256 "9f9f6f2afaf2e8fa4540949c0081b20e4a326b487f4a9234437b3dffac9824cb"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2356052ea314983e453d0cd75a67cba6e554324b94e3380545a8d298454a281b"
    sha256 cellar: :any, arm64_tahoe:       "b93e91516d2b1c8163b240e0cedd02f13624f37cdaff7944e6bd1baf16a641a7"
    sha256 cellar: :any, arm64_sequoia:     "983519ee74a890f271e76fb83d2c41c86e35915fa1f1257c071907b08c5debb5"
    sha256 cellar: :any, arm64_linux:       "7fc2ef833b781bc739e5691e8ca4a5236162dc9f86af6e3b3c56090a6096165c"
    sha256 cellar: :any, x86_64_linux:      "eee19786d2ae96ff06df2edf7bcec9ddce7816b7ba30dc9ea76ebad55c9e38eb"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "fizz" => [:build, :test]
  depends_on "mvfst" => [:build, :test]
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"

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

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 20)

      list(APPEND CMAKE_MODULE_PATH "#{formula_opt_libexec("fizz")}/cmake")
      list(APPEND CMAKE_MODULE_PATH "#{formula_opt_libexec("fbthrift")}/cmake")
      find_package(FBThrift CONFIG REQUIRED)
      find_package(wangle CONFIG REQUIRED)
      find_package(fb303 CONFIG REQUIRED)

      add_executable(test test.cpp)
      target_link_libraries(test fb303::fb303_thrift_cpp)
    CMAKE

    ENV.delete "CPATH" if OS.mac?
    if Tab.for_formula(Formula["folly"]).built_as_bottle
      ENV.remove_from_cflags "-march=native"
      ENV.append_to_cflags "-march=#{Hardware.oldest_cpu}" if Hardware::CPU.intel?
    end

    args = OS.mac? ? [] : ["-DCMAKE_BUILD_RPATH=#{lib};#{HOMEBREW_PREFIX}/lib"]
    system "cmake", "-S", ".", "-B", ".", *args, *std_cmake_args
    system "cmake", "--build", "."
    assert_equal "BaseService", shell_output("./test").strip
  end
end