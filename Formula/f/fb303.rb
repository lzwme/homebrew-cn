class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghfast.top/https://github.com/facebook/fb303/archive/refs/tags/v2026.04.27.00.tar.gz"
  sha256 "75169a53aa4d01bb1959c029f4c34ff1e0f4db2348812d7376788773c19514cc"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "23f0240c7a439f97e6c6fc6145787add0d5dbaddc73a7ee19f9b6f902c7b159e"
    sha256                               arm64_sequoia: "bb907685114381158a74c0e2c2cec94c34d89da6a9eddbb54809ce6adc8b5875"
    sha256                               arm64_sonoma:  "41793e4a3d20df04a424b5bd09d06d7fbe24961bc111ec7258e5e5b05b648cb4"
    sha256 cellar: :any,                 sonoma:        "62f371d187f984d99ace290879d09e6fe39dfb146788c8cce60c1e2b98100e44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7b0185930e0396aceeaa5a33b1d80e2bb2a622b6048710c06ec47d5dd58823e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afef2b5a6e3215292010818d905e64adb19bed86169aa50b065cc90e8c41bf73"
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

      list(APPEND CMAKE_MODULE_PATH "#{Formula["fizz"].opt_libexec}/cmake")
      list(APPEND CMAKE_MODULE_PATH "#{Formula["fbthrift"].opt_libexec}/cmake")
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