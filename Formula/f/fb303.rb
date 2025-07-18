class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://ghfast.top/https://github.com/facebook/fb303/archive/refs/tags/v2025.07.14.00.tar.gz"
  sha256 "2fb7279e4d1023aa80eb4420051810aede315cb764e0cc4d7baa66554e652552"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "3c754a4977080e33407df5a1f4ddf2604adfdad47a664d520ddee7b9d521af16"
    sha256                               arm64_sonoma:  "c532c4bcce1e9734aa3576dc8b08667c1bc9a0f353d01d9775ae41f361393b6d"
    sha256                               arm64_ventura: "b5beb3705524e57e511e562994ab182a3af8f0e0cebaaf94b1434dffff06a551"
    sha256 cellar: :any,                 sonoma:        "db2b9989443f2b285625be13a8656d30ddda5f56fe84c74285f5fa0312d39ed4"
    sha256 cellar: :any,                 ventura:       "f4b5778c408f5ca6021f26ae658b908d83484233f37bda3788068e9fc62edf8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d356a20ab5598ca99dad74d5ff6848ed2c688f78305a02906408b79e5ff15e6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74ffa33fa9062628d8ec68298133da498f218b3d0d61993760c5577561e3f035"
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

  def install
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-DPYTHON_EXTENSIONS=OFF", *shared_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "fb303/thrift/gen-cpp2/BaseService.h"
      #include <iostream>
      int main() {
        auto service = facebook::fb303::cpp2::BaseServiceSvIf();
        std::cout << service.getGeneratedName() << std::endl;
        return 0;
      }
    CPP

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
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end