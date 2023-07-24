class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghproxy.com/https://github.com/facebook/fb303/archive/refs/tags/v2023.07.17.00.tar.gz"
  sha256 "355966953b6c62ee10421d804dac8d0c098e0e65265a1f2ba502ea4f6ce4724d"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "10cb9208634a85b928b96d292cb19d0fd957f26beb1acdc1a2df352103c318d3"
    sha256 cellar: :any,                 arm64_monterey: "620a8dc50de1b6853dc6b468dda588b4d169edca1e4899c167c6543a1dc7619e"
    sha256 cellar: :any,                 arm64_big_sur:  "37998fb91e164e35b9714d9c0fb709f9a3c7298a6ffffc24b5af8e8894e3142b"
    sha256 cellar: :any,                 ventura:        "b6f1eb2057f84e36694c7d1932184c10e710c1167a57e9496cf021666598af9a"
    sha256 cellar: :any,                 monterey:       "17056121e44fa6b914940feb69a43ac2fe2ceca6f3938e652cc44bd926bced62"
    sha256 cellar: :any,                 big_sur:        "946443081991d657939a1fa4ffed82448d8280d834fc4e751143a6f09d656c91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f6abe119955d45372f0623d89ee5a3ec38b1ca87dddbf553accc0a1d7b5f94e"
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