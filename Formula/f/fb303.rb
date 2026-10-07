class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghfast.top/https://github.com/facebook/fb303/archive/refs/tags/v2026.10.05.00.tar.gz"
  sha256 "9342b2c6aa2234cf377ecd8b1f190a69324d7dd454547f23e4558eccba21bfbb"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8b5ed42766082f5546cde905ba4be5e5e0f34b68f90096dc0b356596732de959"
    sha256 cellar: :any, arm64_tahoe:       "098fe0e0385065a3229a0cb689cfb6d97a01654b05b1d076f3be1f642241f692"
    sha256 cellar: :any, arm64_sequoia:     "ad796badd63177adbf504054f50b9576f54d347144b3d925d30a83910a367c12"
    sha256 cellar: :any, arm64_linux:       "c894304fb010f6aadf7bb55b286ac71ecb6c0a62bff1755270aaf2d9714d6c2a"
    sha256 cellar: :any, x86_64_linux:      "c4e169fcafac04faba2913d0a839abe93031b287accfde12b11f98f2b5561b6f"
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
    folly = Formula["folly"]
    if Tab.for_formula(folly).built_as_bottle
      ENV.remove_from_cflags "-march=native"
      ENV.append_to_cflags "-march=#{Hardware.oldest_cpu}" if Hardware::CPU.intel?
    end

    openssl = folly.deps.find { |dep| dep.name.start_with?("openssl@") }
    ENV.append_path "CMAKE_PREFIX_PATH", formula_opt_prefix(openssl.name)

    args = OS.mac? ? [] : ["-DCMAKE_BUILD_RPATH=#{lib};#{HOMEBREW_PREFIX}/lib"]
    system "cmake", "-S", ".", "-B", ".", *args, *std_cmake_args
    system "cmake", "--build", "."
    assert_equal "BaseService", shell_output("./test").strip
  end
end