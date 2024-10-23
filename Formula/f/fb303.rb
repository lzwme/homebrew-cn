class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2024.10.21.00.tar.gz"
  sha256 "3d6ce69e1b297eca1052fdc7908b500f07a994fb11872c7e57ebb291c91dab4e"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2a722e61b6652504885573b1f5a7b214346adc78aafdf8c6ae55c7bda639a633"
    sha256 cellar: :any,                 arm64_sonoma:  "605a8ca580e5529a1102dec56f13143de1b2d251c34a4df712effb73dbead9e1"
    sha256 cellar: :any,                 arm64_ventura: "991df2912211b272d491b24a9ec96772933779b0ee7a9a5affe81afa729fefbf"
    sha256 cellar: :any,                 sonoma:        "c6d64eb9f3fb5fb2d3240c24f4b0f69effab548066f052369aa6b36bfcff0977"
    sha256 cellar: :any,                 ventura:       "f6d611d394b49f02e2fd0d613c7dce71c3d1997639647916bc42cbcf9ee7be4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3d7e6cfd8536e9af83380e437ce3a9eba9492f25e7a3e6f40627d4fd5ee6106"
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
                    "-ldl"
    assert_equal "BaseService", shell_output(".test").strip
  end
end