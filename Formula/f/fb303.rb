class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghproxy.com/https://github.com/facebook/fb303/archive/refs/tags/v2023.11.27.00.tar.gz"
  sha256 "285407f581b696840fe785b618b77b51e65f09f40fb9944664e5505aa0caff23"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "18d1e60e4935991006f991aa00326f39026d4af714ae5b1d5fb6f54fa0ae8d59"
    sha256 cellar: :any,                 arm64_ventura:  "21ad0a8a9dd7ad73ae370ae17f5b9c2cec68d9731d724c40ca21cdd3231eb86f"
    sha256 cellar: :any,                 arm64_monterey: "d70db54fe9836bbace3ad628ffb0490622da35ea4f1947e6fbc6bc17795f6b66"
    sha256 cellar: :any,                 sonoma:         "39a2a5e7ca69ea42761743f4aaa521926ef45e2a75037a5d9c6fde8ac4234558"
    sha256 cellar: :any,                 ventura:        "e46945b3ca9f2d8dbdfd8cb82cadf84f1247b14bfbf383fc93d189c6c7a385ac"
    sha256 cellar: :any,                 monterey:       "9a2d12a84d0fd70032652c9f92256b6a92654a17ea7fceb2e06eb3e6fd657590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a74b273be7f0ce66a0639c641b85d4235b154324dbb17683f186c1a7150e05d7"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift" => [:build, :test]
  depends_on "mvfst" => :build
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "wangle"

  fails_with gcc: "5" # C++17

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXTENSIONS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "fb303/thrift/gen-cpp2/BaseService.h"
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
    assert_equal "BaseService", shell_output("./test").strip
  end
end