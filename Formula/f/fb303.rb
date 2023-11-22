class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghproxy.com/https://github.com/facebook/fb303/archive/refs/tags/v2023.11.20.00.tar.gz"
  sha256 "7653ebc37a9a954c9cc9cfbcb918a694e6740d206673463892b3defaa35384d9"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "92ec826009a01941d7858c4a2672d5213de955342239dffaaf3c5c884bc8ba48"
    sha256 cellar: :any,                 arm64_ventura:  "4e220f887dea5a8a06f7aa9463b1c3eb57b440f60c0da2437fe9d63683cd29fe"
    sha256 cellar: :any,                 arm64_monterey: "54d1bfad370c33f4e1d438ecda3fef559fd94dd8800b387cb4e9611b7911b461"
    sha256 cellar: :any,                 sonoma:         "f6c19b85b2fdff62fcf57c5eea297b1c902d7ab5f1a98e5ef771d42c259cd6b9"
    sha256 cellar: :any,                 ventura:        "dc073c41bcf3ded205110e3f1f3d4a5a6235207d915f33340dc717ac2a5242d5"
    sha256 cellar: :any,                 monterey:       "ffb9c5a22262050384ef35bc52cda9006aaa5ce851b5a411a3b650444758433c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49ecd4f10300c372521576d19e178e504e96501332b230bfa386799ab6cf0f45"
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