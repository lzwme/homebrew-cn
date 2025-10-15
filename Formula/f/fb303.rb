class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghfast.top/https://github.com/facebook/fb303/archive/refs/tags/v2025.10.13.00.tar.gz"
  sha256 "3355d537043ba826a26e8bb8820f9f02257b5ad1d1ebc3e657fc1f7993bb0e04"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "ba93aad3ace3a810493a48a1d8e7fb6f9473a8c7c9f29a3a83a6ef6ec33fb66c"
    sha256                               arm64_sequoia: "dd92246d89b5b923c7b7d05cdbddb375178d755f0bd640082b681531b99c3170"
    sha256                               arm64_sonoma:  "8c9c550ae1a6cce6df9d13c9cf9de943d0f1913d9c8fe105d19336c84b029fef"
    sha256 cellar: :any,                 sonoma:        "953fcb18a4abb69a9cdf9d51e8eef6316736f3db9d9ce0fee3f4c896705571d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f30a2c7d1b791fcb81e9082fbbb21ba716d6532fe698b0c27fb1f6828842f46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c09d8d929ecd4cadf55a11dd4b531399c69d49306fe4fa04e2cd15a4702a8f4"
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
                    "-lthriftmetadata", "-lthrifttyperep", "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end