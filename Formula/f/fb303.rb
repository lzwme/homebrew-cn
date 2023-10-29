class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghproxy.com/https://github.com/facebook/fb303/archive/refs/tags/v2023.10.23.00.tar.gz"
  sha256 "03595e55611fcd01a736e7cec48f2195a60c82098d77b1531bf64ff60b5ed195"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "caf12d4757d381e77e004783c2da73c85148d25e851b0eeb4b822b4099073553"
    sha256 cellar: :any,                 arm64_ventura:  "681a105e906d42e7b85e9ddb5ad5c2655e634985d8cc8e8c5f36bb2a63fcdd39"
    sha256 cellar: :any,                 arm64_monterey: "4bcbf847efdd154b24aad2c0b73fdab2340d1b4bb0aaf18efadcd9009180bd03"
    sha256 cellar: :any,                 sonoma:         "03e736bc0be18cbcbf508dea210ee9b55538ffae535b831db2443c4a4071cb2e"
    sha256 cellar: :any,                 ventura:        "e78abf3e306eac2dbce2ba15f7cfcd64dd2ba723e8292f270536cc43b10a264c"
    sha256 cellar: :any,                 monterey:       "071981886635aa8d72ffa41d66723b39486efa3bf7de37443e67b2c2c97f0452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c267c6bb40c70c8a026f949708a9e0e3b5295ec2700743a67fb29ece917304a6"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift" => [:build, :test]
  depends_on "mvfst" => :build
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
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