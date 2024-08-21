class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https:github.comfacebookfb303"
  url "https:github.comfacebookfb303archiverefstagsv2024.08.19.00.tar.gz"
  sha256 "8f5b5e627f02f60d06f751753801ae0776df3ca6f1fbff2c8b84524b04dc6a1c"
  license "Apache-2.0"
  head "https:github.comfacebookfb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0b955202cb3273273c6f6b2387e5725bc9723022ca870ca3d1b6f488bc32082c"
    sha256 cellar: :any,                 arm64_ventura:  "13ec91d849bf985b8077ffa8c63bd7399a24c947a8484c87d46ec47d42fae40f"
    sha256 cellar: :any,                 arm64_monterey: "d1ab3bfadb4c492d21c06a10499fbb0469e778934aa0bc828c44cf75be098e25"
    sha256 cellar: :any,                 sonoma:         "dcd09fbce1fcc985de6a06c8fb6bf31070fdaeb909cd2fb904417a908a6462f2"
    sha256 cellar: :any,                 ventura:        "42ac4d14e09c2f04bc0ddf6008e4707330b9cf05848cbdfd75096a1eed6f5e3c"
    sha256 cellar: :any,                 monterey:       "f1827acb58bb54e5ee5ef9c295e34c5a1f60257f74d010528685212e42c1de16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f8fe1f7769449273397798ba6a0291f607a4543306a71c99e2d6cd86a5d13a7"
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
                    "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl"
    assert_equal "BaseService", shell_output(".test").strip
  end
end