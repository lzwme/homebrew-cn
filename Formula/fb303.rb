class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghproxy.com/https://github.com/facebook/fb303/archive/v2023.03.27.00.tar.gz"
  sha256 "dcc093f16a202ffbc09104d72372da81c8ce6611240a6fd7ff8aeff238711592"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8793d418784e5c5b462b9f9d8417f2ee125793b4ee15ac3f08097c0d9d5826a0"
    sha256 cellar: :any,                 arm64_monterey: "81d43135cd3ced54ea7f41d2613605d5ff7dd1fe335a16bf2b3ce11daf7f7a88"
    sha256 cellar: :any,                 arm64_big_sur:  "9482db81c6fbb08f3f3e908c7a70f0aac8104533ee664e56424e08f0b8719a98"
    sha256 cellar: :any,                 ventura:        "41038cfa224a1c2e90cb54968ea16ba3a7f306d2bad772e80088e98439f83f37"
    sha256 cellar: :any,                 monterey:       "cdd226dc77ad119647863aedc1ace866fe7c555ce90c7e2d446707afb6c26727"
    sha256 cellar: :any,                 big_sur:        "e1ae625f5c1aaa75eda623c02bc9e5f87684f208504c650b9f1272ca7b2af685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbf48fa6a5dbb4b3338fbd94148b8f3fefd94c8d1c429bc12a9e2c5b7a09a8d8"
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