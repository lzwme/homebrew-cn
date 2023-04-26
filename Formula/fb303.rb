class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghproxy.com/https://github.com/facebook/fb303/archive/refs/tags/v2023.04.24.00.tar.gz"
  sha256 "381cab97fbeea722a7b9ff6efa1483916bb77e6806c3bf8b92fdd618386f5033"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cf26c663d801bcda75c7fab2bee14b08b98d3807875f13519467d9af970c86d4"
    sha256 cellar: :any,                 arm64_monterey: "f234b1afd523d0c4dde3ca2e12953283599df45a9ad6aa2819b6720834d24aa8"
    sha256 cellar: :any,                 arm64_big_sur:  "3077746c82d5e20bd022dd4eb98cace753aa8a6f7261b3d279ac9d982b37fa14"
    sha256 cellar: :any,                 ventura:        "98d8d3045044c7c733019cbe1c9af2463748c20634082598a17e06fbc36da0c2"
    sha256 cellar: :any,                 monterey:       "65630f48a4509373df021e63eb9fb5f5432103bed9e26492abd66c21b7f7fb24"
    sha256 cellar: :any,                 big_sur:        "9077dc963004720a61b989bc3fc4ca570c3d7f75202f4b9f45561eb934050f5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c71c286889a2992045c47a4ce5cb187032850b73315c38ec90ec8f2fa87221f0"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@1.1"
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
                    "-I#{include}", "-I#{Formula["openssl@1.1"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end