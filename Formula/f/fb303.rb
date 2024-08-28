class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2024.08.19.00.tar.gz"
  sha256 "8f5b5e627f02f60d06f751753801ae0776df3ca6f1fbff2c8b84524b04dc6a1c"
  license "Apache-2.0"
  revision 1
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bc8106fe5e0af8d1dff5263e4f1d362c34b591f5301ef67165c92214d6d16d53"
    sha256 cellar: :any,                 arm64_ventura:  "74f76feb142dc9e19c9ea4eec87ca50cb1c5ee57b1a250fb05bdd6c2469cc614"
    sha256 cellar: :any,                 arm64_monterey: "e5b9bfc64a2cd49170b8ca4f89c6d6114af2a9e5ee1b0a640f2cbea2f01a17b6"
    sha256 cellar: :any,                 sonoma:         "68693c501d143288e2b8d8a5fe9020efa877438364768beb6f1c38acfdc30fe2"
    sha256 cellar: :any,                 ventura:        "25265f29208f26946d5ff46a46deaecc16b99a9af51d9314efbad759df190958"
    sha256 cellar: :any,                 monterey:       "dfcc41768321803e2c23a8c90fbc2acdbbf68e48e7c1901501ed130b9ba43401"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3978b40dad2abc30c0d964cd924afc540d58a1bd13220c5d1f481fad0c9e374f"
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