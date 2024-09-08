class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2024.09.02.00.tar.gz"
  sha256 "a6c766f12387dac34538a0d3618374738ab76dff3bfa3d716030c5d46f43fa2f"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ecf5061ad924d38df388fbe4a37313c908c55bc0bcac5bc96a78016167532988"
    sha256 cellar: :any,                 arm64_ventura:  "5fe8707838b8f9f46240042e7ed05b3c9fc1b7df499b84e5cac3f3d932d8995d"
    sha256 cellar: :any,                 arm64_monterey: "385ea7369e7c975ceeb8f399ad9553ebb877f11f8303fbf7feb4b954ab06ecc8"
    sha256 cellar: :any,                 sonoma:         "43642921d597fdafe876b19bd8e6165b1bb9e13c7a929bbcc33128a07f3cffb9"
    sha256 cellar: :any,                 ventura:        "3d72fd316683edf6d4fae7bd9fb095758afd62eae53301a75a5c59150a36daf0"
    sha256 cellar: :any,                 monterey:       "ebaa81d81c3cb32b4d5485efba4954353c601832b4ab67028e80c3e3f2b2880a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64d17a8d59eaea322e01ca627ca5d178427530f333ab98037c190c92add9fecf"
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