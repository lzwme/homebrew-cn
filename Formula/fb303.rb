class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghproxy.com/https://github.com/facebook/fb303/archive/refs/tags/v2023.05.01.00.tar.gz"
  sha256 "3e19a508fe8221e98cd696ac8f4edd4584e2a57ec6aa3b8cb45fe2d0fbf7aa69"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4bd72fd65d51f10a309356d01ea2e147c49cfe06d91929a86524b525934bf67c"
    sha256 cellar: :any,                 arm64_monterey: "7d1315c5605580cc5d10467f8c18a558c1515764e230e388d488df031ac0b215"
    sha256 cellar: :any,                 arm64_big_sur:  "59fb5cdd1e8cf27c2c11dbc562a0aae43b550aa1d8d532e6ac10f1c3574e62ab"
    sha256 cellar: :any,                 ventura:        "a64f0ea4943d9c0f01770338d77f519848a65ca272a55062b0486bb78a2da9ca"
    sha256 cellar: :any,                 monterey:       "a035617d808bc105c3befc316fa2aa89017a861643c2a3e68f13cd571e11f014"
    sha256 cellar: :any,                 big_sur:        "248f3c690137c14b8adcaefc1a8998026c16f42efbc1f5134b01b89736a2a0a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f826892700649a8662c55c798aa30fe18c5106ee56773314650656a1fdf96e1"
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