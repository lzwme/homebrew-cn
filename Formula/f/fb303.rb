class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghproxy.com/https://github.com/facebook/fb303/archive/refs/tags/v2023.09.25.00.tar.gz"
  sha256 "2bcd19b2c2961da8117c4ba568e4c7fe75fcd2df006cdaf00351d22f9ffc1689"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "607abe881054969ad56448b2365f999b7cf6fc21aa12159e9d6a509bde38c67e"
    sha256 cellar: :any,                 arm64_ventura:  "cc8a0774e48f8f00e3f071eab79b2c709032eeb6ef1b75814f90b323644efd20"
    sha256 cellar: :any,                 arm64_monterey: "f0b55af673ef034cae0d54edab54e687e0c4724a571276c4ef898877e9c880dc"
    sha256 cellar: :any,                 sonoma:         "3bf58fbb880d33225ecc6a83eb44f0aa75b0832a9face6a46e4a4c70c670779b"
    sha256 cellar: :any,                 ventura:        "bedd306ae83f41a665e386a3df04d239f84ebe976192f990816fcf8ca3d98f8d"
    sha256 cellar: :any,                 monterey:       "ff3ac6f84541f5d2322041c4c92a9157748f8ae00af470a19a58960b6ae35bdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b40d939fd51dbf8579cf7c0d86b0a3082de817f86cb5ca4d83538f5fe3c54d6"
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