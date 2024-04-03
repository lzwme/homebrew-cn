class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2024.04.01.00.tar.gz"
  sha256 "37380585b0832be248dc3c29d7890e6b35b40596334fee2fa05a4191bd6c623c"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a76ef233c4a1557aa0ce94d4b01a6d6cc5a70f1d75bb9a815088f5421aefd104"
    sha256 cellar: :any,                 arm64_ventura:  "24769f9d1aeb426aa501aca8d32ae13762901a03459691416d53d361151cceae"
    sha256 cellar: :any,                 arm64_monterey: "e6fcb31d171f3fb9ca870445e5354876f0725031af1a2ba70f1019c8c85d3e20"
    sha256 cellar: :any,                 sonoma:         "a7508c370925fd1215fddbc93d3fe593aa9e7fbdebc0887c6a65cdb4d8e1701c"
    sha256 cellar: :any,                 ventura:        "4c1b8b361358ca6cd50498b269fdc8a26ae03b3bf88fb8812d88d44612ae412e"
    sha256 cellar: :any,                 monterey:       "33f3583adb14904a971758584962f1a8e2b2cc3730354aba5e63e1200c7bb9b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab62ae4c15df4bb4efef383e12314138412b922c0d0ccb588a9a8d246e0cf1b8"
  end

  depends_on "cmake" => :build
  depends_on "mvfst" => :build
  depends_on "fbthrift"
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