class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghfast.top/https://github.com/facebook/fb303/archive/refs/tags/v2026.05.18.00.tar.gz"
  sha256 "d0da2ac576f66338c8325fce1d0d3fcff11c4f87b2249d7dc27cc26b0e3615a5"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "495f4e9c8e83d7194cebba9fc5c496ce7149190b4112c49c2174c51788e94e5c"
    sha256                               arm64_sequoia: "3069f3d08cb4c7a832455589ac09b6d9e92867ee26ea94c7b1bf91f7f077bdd2"
    sha256                               arm64_sonoma:  "fa3a65178af3b9c96886c55f2d441a6f719b6675e3f5ad3cc658a513b937e07f"
    sha256 cellar: :any,                 sonoma:        "6b25cd1766a5dec7decf0d7894223c4bff76d851aa30a81a7e5ce0e0e3cfc548"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63b5f0b1b65cf48a94039e65d0cbde7e689243a5b25bc988e8d27ddce59ae5df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60243d307d7422146aef9ac5c8b082e044307504dd5943af66078eb15733b3c9"
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